# State Management for ChatGPT Widgets

> **Official Source**: https://developers.openai.com/apps-sdk/build/state-management
>
> For latest patterns, fetch from official documentation.

## Three State Categories

### 1. Business Data (Authoritative)

**Owner**: MCP Server / Backend
**Lifetime**: Long-lived, persists across sessions
**Examples**: Tasks, tickets, documents, user records

```typescript
// Server returns authoritative data in toolOutput
const tasks = window.openai?.toolOutput?.tasks;
```

**Key Rule**: Server is the single source of truth. Never let UI diverge.

---

### 2. UI State (Ephemeral)

**Owner**: Widget instance
**Lifetime**: Message-scoped (exists only while widget is active)
**Examples**: Selections, expanded panels, sort order, scroll position

```typescript
// Read current widget state
const uiState = window.openai?.widgetState;

// Write state (sync call, async persistence)
window.openai?.setWidgetState({
  selectedId: 5,
  expandedPanels: ['details', 'comments'],
  sortOrder: 'newest'
});
```

**Key Rule**: Widget state only persists for that message's widget instance.

---

### 3. Cross-Session State (Durable)

**Owner**: Backend storage
**Lifetime**: Persistent across conversations
**Examples**: Saved filters, workspace preferences, user settings

```typescript
// Store in backend, not widget
await window.openai?.callTool('save_preferences', {
  filters: userFilters,
  theme: selectedTheme
});
```

**Key Rule**: Requires backend storage + user authentication.

---

## Widget Architecture

Widgets are **message-scoped instances**:

```
Conversation
├── Message 1
│   └── Widget Instance A (own widgetState)
├── Message 2
│   └── Widget Instance B (own widgetState)
└── Message 3
    └── Widget Instance C (own widgetState)
```

Each widget instance has isolated state. When ChatGPT renders a custom UI, it creates a fresh widget tied to that specific message.

---

## State Synchronization Pattern

```
┌──────────────────────────────────────────────────────────────┐
│                     STATE FLOW                               │
├──────────────────────────────────────────────────────────────┤
│                                                              │
│  1. User clicks "Complete Task" in widget                    │
│                    ↓                                         │
│  2. Widget calls: callTool('complete_task', { id: 5 })       │
│                    ↓                                         │
│  3. Server updates database (authoritative data)             │
│                    ↓                                         │
│  4. Server returns new snapshot in structuredContent         │
│                    ↓                                         │
│  5. Widget receives new toolOutput                           │
│                    ↓                                         │
│  6. Widget re-renders with new data + preserved UI state     │
│                                                              │
└──────────────────────────────────────────────────────────────┘
```

**Important**: Widget only sees updated business data when a tool call completes. It then reapplies local UI state on top of that snapshot.

---

## Widget State API

### Reading State
```typescript
// Direct access
const state = window.openai?.widgetState;

// React hook (recommended)
const [state, setState] = useWidgetState({
  selectedItems: [],
  viewMode: 'grid'
});
```

### Writing State
```typescript
// Sync call, async persistence
window.openai?.setWidgetState({
  selectedItems: [1, 2, 3],
  viewMode: 'list',
  expandedId: 5
});
```

### Structured State for Images
```typescript
{
  modelContent: string | JSON | null,  // Text for model reasoning
  privateContent: object | null,        // UI-only data
  imageIds: string[]                     // Uploaded file IDs
}
```

The `imageIds` array exposes uploaded files to the model for reasoning on follow-up turns.

---

## Critical Constraints

### ❌ Avoid localStorage
```typescript
// BAD - Don't rely on this
localStorage.setItem('widgetState', JSON.stringify(state));
```
Widget state doesn't persist reliably in localStorage.

### ❌ No Automatic Re-sync
Widget must manually re-apply local state when new data arrives:
```typescript
useEffect(() => {
  // New data arrived, re-apply UI state
  if (newData && savedSelections) {
    // Filter saved selections to only valid items
    const validSelections = savedSelections.filter(
      id => newData.items.some(item => item.id === id)
    );
    setLocalSelections(validSelections);
  }
}, [newData]);
```

### ✅ Keep State Small
```typescript
// GOOD - Essential UI state only
{ selectedId: 5, expanded: true }

// BAD - Too much data
{ selectedId: 5, expanded: true, allItems: [...1000 items...] }
```
widgetState is shown to model - keep under 4KB tokens.

### ✅ Message-Scoped Persistence
Each message's widget has its own state. State from Message 1's widget doesn't affect Message 3's widget.

---

## Cross-Session Persistence Pattern

For data that must outlive widget instances:

```typescript
// 1. User modifies preferences in widget
const handleSavePreferences = async (prefs) => {
  // 2. Call server to persist
  await window.openai?.callTool('save_user_preferences', {
    filters: prefs.filters,
    defaultView: prefs.view
  });

  // 3. Server stores in database (with user auth)
  // 4. Next conversation loads preferences from server
};
```

**Requirements**:
- User authentication via OAuth
- Low-latency APIs (hundreds of ms)
- Schema versioning for backward compatibility

---

## React Implementation

```typescript
function TaskWidget() {
  // Business data from server
  const tasks = useToolOutput<Task[]>();

  // UI state (ephemeral, widget-scoped)
  const [uiState, setUiState] = useWidgetState({
    selectedId: null,
    sortOrder: 'newest'
  });

  // Handle action -> sync with server
  const handleComplete = async (taskId: string) => {
    const result = await window.openai?.callTool('complete_task', { id: taskId });
    // Widget will re-render with new tasks from result.structuredContent
  };

  // Re-apply UI state when data changes
  const sortedTasks = useMemo(() => {
    if (!tasks) return [];
    return [...tasks].sort((a, b) =>
      uiState.sortOrder === 'newest'
        ? b.createdAt - a.createdAt
        : a.createdAt - b.createdAt
    );
  }, [tasks, uiState.sortOrder]);

  return (
    <TaskList
      tasks={sortedTasks}
      selectedId={uiState.selectedId}
      onSelect={(id) => setUiState(s => ({ ...s, selectedId: id }))}
      onComplete={handleComplete}
    />
  );
}
```
