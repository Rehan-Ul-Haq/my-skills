# window.openai API Reference

> **Official Source**: https://developers.openai.com/apps-sdk/build/chatgpt-ui/
>
> For latest API updates, fetch from official documentation.

Complete reference for the `window.openai` global object injected into ChatGPT widgets.

---

## State & Data Properties

### toolOutput
Data returned by MCP server in `structuredContent`. Primary data source.

```typescript
const data = window.openai?.toolOutput;
// Example: { items: [...], total: 10, status: 'success' }
```

### toolInput
Arguments passed to the tool invocation.

```typescript
const args = window.openai?.toolInput;
// Example: { moduleId: 1, chapterId: 5 }
```

### toolResponseMetadata
Private `_meta` payload from server (NOT sent to model).

```typescript
const meta = window.openai?.toolResponseMetadata;
// Example: { full_content: '...50KB markdown...', cache_status: 'hit' }
```

### widgetState
Persisted UI state. Survives conversation turns when widget triggers follow-ups.

```typescript
const state = window.openai?.widgetState;
// Example: { expandedSections: [1, 3], currentPage: 2 }
```

### theme
Current ChatGPT theme: `'light'` or `'dark'`.

```typescript
const theme = window.openai?.theme; // 'light' | 'dark'
```

### displayMode
Current display mode: `'inline'`, `'fullscreen'`, or `'pip'`.

```typescript
const mode = window.openai?.displayMode;
```

### maxHeight
Maximum height for inline widgets (pixels).

```typescript
const maxH = window.openai?.maxHeight; // e.g., 400
```

### safeArea
Safe area insets for fullscreen (notches, etc).

```typescript
const safe = window.openai?.safeArea;
// { top: number, right: number, bottom: number, left: number }
```

### locale
User's locale for i18n.

```typescript
const locale = window.openai?.locale; // e.g., 'en-US', 'es-ES'
```

---

## Methods

### setWidgetState(state)
Persist UI state. State is shown to model and hydrated on follow-ups.

```typescript
window.openai?.setWidgetState({
  selectedItems: [1, 2, 3],
  filters: { status: 'active' },
});
```

**Important**: Keep under 4KB tokens.

### callTool(name, args)
Invoke MCP tool from widget. Returns promise.

```typescript
const result = await window.openai?.callTool('submit_quiz', {
  moduleId: 1,
  answers: { q1: 0, q2: 2 }
});

const score = result?.structuredContent?.score;
```

### sendFollowUpMessage(options)
Send message to conversation on behalf of user.

```typescript
await window.openai?.sendFollowUpMessage({
  prompt: 'Show me the next chapter'
});
```

### requestDisplayMode(options)
Request display mode change.

```typescript
// Fullscreen
await window.openai?.requestDisplayMode({ mode: 'fullscreen' });

// Back to inline
await window.openai?.requestDisplayMode({ mode: 'inline' });

// Picture-in-picture
await window.openai?.requestDisplayMode({ mode: 'pip' });
```

### requestClose()
Close the widget.

```typescript
window.openai?.requestClose();
```

### notifyIntrinsicHeight(options)
Report dynamic height to prevent clipping.

```typescript
window.openai?.notifyIntrinsicHeight({ height: 500 });
```

### openExternal(options)
Open vetted external link.

```typescript
window.openai?.openExternal({ href: 'https://example.com/docs' });
```

### uploadFile(file)
Upload image (PNG, JPEG, WebP).

```typescript
const file = input.files[0];
const { fileId } = await window.openai?.uploadFile(file);
```

### getFileDownloadUrl(options)
Get temporary download URL.

```typescript
const { url } = await window.openai?.getFileDownloadUrl({ fileId: 'abc123' });
```

---

## Events

### openai:set_globals
Fired when any global property changes.

```typescript
window.addEventListener('openai:set_globals', (event) => {
  const { globals } = (event as CustomEvent).detail;
  if (globals.toolOutput !== undefined) {
    // Handle new data
  }
});
```

### openai:themeChanged
Fired when theme changes.

```typescript
window.addEventListener('openai:themeChanged', () => {
  const newTheme = window.openai?.theme;
  updateStyles(newTheme);
});
```

---

## TypeScript Declarations

```typescript
declare global {
  interface Window {
    openai?: {
      // State
      toolOutput?: Record<string, unknown>;
      toolInput?: Record<string, unknown>;
      toolResponseMetadata?: Record<string, unknown>;
      widgetState?: Record<string, unknown>;
      theme?: 'light' | 'dark';
      displayMode?: 'inline' | 'fullscreen' | 'pip';
      maxHeight?: number;
      safeArea?: { top: number; right: number; bottom: number; left: number };
      locale?: string;

      // Methods
      setWidgetState: (state: Record<string, unknown>) => void;
      callTool: (name: string, args: Record<string, unknown>) => Promise<{
        structuredContent?: Record<string, unknown>;
      }>;
      sendFollowUpMessage: (options: { prompt: string }) => Promise<void>;
      requestDisplayMode: (options: { mode: string }) => Promise<void>;
      requestClose: () => void;
      notifyIntrinsicHeight: (options: { height: number }) => void;
      openExternal: (options: { href: string }) => void;
      uploadFile: (file: File) => Promise<{ fileId: string }>;
      getFileDownloadUrl: (options: { fileId: string }) => Promise<{ url: string }>;
    };
  }
}
```

---

## CSP Configuration

> **Official Source**: https://developers.openai.com/apps-sdk/build/chatgpt-ui

Widgets run in iframes with Content Security Policy. Configure via response metadata:

```typescript
{
  metadata: {
    "openai/widgetCSP": {
      "connect_domains": ["https://your-api.com"],      // API calls
      "resource_domains": ["https://cdn.example.com"],  // Static assets
      "redirect_domains": ["https://checkout.example.com"], // External redirects
      "frame_domains": ["https://*.example.com"]        // Embedded iframes (strict review)
    }
  }
}
```

| Domain Type | Purpose | Review Level |
|-------------|---------|--------------|
| `connect_domains` | Fetch/XHR to external APIs | Standard |
| `resource_domains` | Images, scripts, styles | Standard |
| `redirect_domains` | `openExternal` destinations | Standard |
| `frame_domains` | Embedded iframes in widget | **Stricter review** |

**Widget Session ID**: Use `metadata["openai/widgetSessionId"]` to correlate multiple tool calls within the same widget instance.

**Close Widget**: Set `metadata["openai/closeWidget"]: true` to close from server side.

---

## Common Patterns

### Safe Data Access
```typescript
function getData<T>(defaultValue: T): T {
  return (window.openai?.toolOutput as T) ?? defaultValue;
}

const items = getData<Item[]>([]);
```

### Reactive Updates (Vanilla JS)
```typescript
function init() {
  render();
  window.addEventListener('openai:set_globals', render);
}
```

### Mock for Local Development
```typescript
if (!window.openai) {
  window.openai = {
    toolOutput: { items: [{ id: 1, name: 'Test' }] },
    theme: 'light',
    setWidgetState: (s) => console.log('setWidgetState', s),
    callTool: async (n, a) => ({ structuredContent: { success: true } }),
  } as any;
}
```
