# Display Modes Reference

> **Official Source**: https://developers.openai.com/apps-sdk/concepts/ui-guidelines
>
> For latest updates, fetch from official documentation.

ChatGPT widgets support three display modes for different use cases.

---

## Inline Mode (Default)

Appears directly in conversation flow before model response.

**Best For**:
- Single actions
- Small data sets
- Self-contained widgets
- Quick interactions

**Constraints**:
- No deep navigation
- No nested scrolling
- No duplicative inputs
- **Maximum 2 actions** at bottom
- Height expands to mobile viewport max

**Implementation**:
```typescript
// Inline is default - no action needed
// Report dynamic height to prevent clipping
window.openai?.notifyIntrinsicHeight({ height: calculatedHeight });
```

---

## Inline Carousel

Side-by-side cards for multiple similar items.

**Best For**:
- Product listings
- Search results
- Media galleries
- Option selection

**Guidelines**:
- **3-8 items** per carousel for scannability
- Each item: image + title + metadata (max 3 lines)
- Support horizontal scrolling
- Clear selection indicators

```html
<div style="display: flex; overflow-x: auto; gap: 12px; padding: 8px 0;">
  <div style="flex: 0 0 180px; /* card content */"></div>
  <!-- More cards -->
</div>
```

---

## Fullscreen Mode

Immersive experiences for complex workflows.

**Best For**:
- Multi-step workflows
- Deep exploration
- Rich editing tasks
- Detailed content browsing
- Maps and visualizations

**Key Points**:
- ChatGPT composer remains overlaid
- Must handle safe area insets
- Provide clear exit mechanism

**Request Fullscreen**:
```typescript
await window.openai?.requestDisplayMode({ mode: 'fullscreen' });
```

**Handle Safe Areas**:
```typescript
const safeArea = window.openai?.safeArea ?? { top: 0, right: 0, bottom: 0, left: 0 };

const containerStyle = {
  paddingTop: `${safeArea.top}px`,
  paddingRight: `${safeArea.right}px`,
  paddingBottom: `${safeArea.bottom + 80}px`, // Extra for composer overlay
  paddingLeft: `${safeArea.left}px`,
};
```

**Return to Inline**:
```typescript
await window.openai?.requestDisplayMode({ mode: 'inline' });
```

---

## Picture-in-Picture (PiP)

Persistent floating window for parallel activities.

**Best For**:
- Games
- Video playback
- Live sessions
- Ongoing monitoring

**Characteristics**:
- Stays visible during conversation
- Updates dynamically
- Auto-dismiss when session ends
- Compact, focused UI

**Request PiP**:
```typescript
await window.openai?.requestDisplayMode({ mode: 'pip' });
```

**Note**: Mobile may coerce PiP to fullscreen automatically.

---

## Mode Selection Guide

| Scenario | Mode | Reason |
|----------|------|--------|
| Quiz results | Inline | Simple display, ≤2 actions |
| Product cards (5 items) | Inline Carousel | Multiple similar items |
| Interactive map | Fullscreen | Complex interaction |
| Code editor | Fullscreen | Rich editing |
| Video player | PiP | Persistent playback |
| Game session | PiP | Ongoing interaction |
| Progress dashboard | Inline | Summary view |
| Multi-page form | Fullscreen | Multi-step workflow |
| Search results | Inline | List display |
| Document viewer | Fullscreen | Detailed content |

---

## Mode-Adaptive Styling

```typescript
const displayMode = window.openai?.displayMode ?? 'inline';

const containerStyle = {
  padding: displayMode === 'inline' ? '16px' : '24px',
  maxWidth: displayMode === 'fullscreen' ? 'none' : '600px',
  minHeight: displayMode === 'fullscreen' ? '100vh' : 'auto',
};
```

---

## Transitions

**Expand (Inline → Fullscreen)**:
```typescript
const handleExpand = async () => {
  await window.openai?.requestDisplayMode({ mode: 'fullscreen' });
};
```

**Minimize (Fullscreen → Inline)**:
```typescript
const handleMinimize = async () => {
  await window.openai?.requestDisplayMode({ mode: 'inline' });
};
```

**Close Widget**:
```typescript
window.openai?.requestClose();
```
