# React Hooks for ChatGPT Widgets

> **Based On**: https://developers.openai.com/apps-sdk/build/chatgpt-ui/
>
> These hooks implement patterns from official OpenAI documentation.

Reusable React hooks for building ChatGPT widgets.

## useToolOutput

Access MCP tool output data with reactive updates.

```typescript
import { useState, useEffect, useSyncExternalStore } from 'react';

const SET_GLOBALS_EVENT = 'openai:set_globals';

export function useToolOutput<T = unknown>(): T | undefined {
  return useSyncExternalStore(
    (onChange) => {
      const handler = (event: Event) => {
        const e = event as CustomEvent;
        if (e.detail?.globals?.toolOutput !== undefined) {
          onChange();
        }
      };
      window.addEventListener(SET_GLOBALS_EVENT, handler);
      return () => window.removeEventListener(SET_GLOBALS_EVENT, handler);
    },
    () => window.openai?.toolOutput as T | undefined,
    () => undefined
  );
}
```

**Usage**:
```typescript
interface ProgressData {
  completionPercent: number;
  chaptersCompleted: number;
  totalChapters: number;
}

function ProgressWidget() {
  const data = useToolOutput<ProgressData>();

  if (!data) return <Loading />;

  return <div>{data.completionPercent}% complete</div>;
}
```

## useToolMeta

Access private _meta payload (toolResponseMetadata).

```typescript
export function useToolMeta<T = Record<string, unknown>>(): T | undefined {
  return useSyncExternalStore(
    (onChange) => {
      window.addEventListener(SET_GLOBALS_EVENT, onChange);
      return () => window.removeEventListener(SET_GLOBALS_EVENT, onChange);
    },
    () => window.openai?.toolResponseMetadata as T | undefined,
    () => undefined
  );
}
```

**Usage**:
```typescript
interface ChapterMeta {
  full_content: string;
  cache_status: string;
}

function ChapterViewer() {
  const meta = useToolMeta<ChapterMeta>();
  const fullMarkdown = meta?.full_content;
  // Render full content from _meta (not sent to model)
}
```

## useTheme

React to ChatGPT theme changes.

```typescript
export type Theme = 'light' | 'dark';

export function useTheme(): Theme {
  const [theme, setTheme] = useState<Theme>(() =>
    (window.openai?.theme as Theme) ?? 'light'
  );

  useEffect(() => {
    const handleChange = () => {
      setTheme((window.openai?.theme as Theme) ?? 'light');
    };

    window.addEventListener('openai:set_globals', handleChange);
    window.addEventListener('openai:themeChanged', handleChange);

    // Also respect system preference as fallback
    const mq = window.matchMedia('(prefers-color-scheme: dark)');
    const handleMedia = (e: MediaQueryListEvent) => {
      if (!window.openai?.theme) {
        setTheme(e.matches ? 'dark' : 'light');
      }
    };
    mq.addEventListener('change', handleMedia);

    return () => {
      window.removeEventListener('openai:set_globals', handleChange);
      window.removeEventListener('openai:themeChanged', handleChange);
      mq.removeEventListener('change', handleMedia);
    };
  }, []);

  return theme;
}
```

**Usage**:
```typescript
function ThemedCard() {
  const theme = useTheme();

  return (
    <div style={{
      backgroundColor: theme === 'dark' ? '#0f172a' : '#ffffff',
      color: theme === 'dark' ? '#f8fafc' : '#0f172a',
    }}>
      Content
    </div>
  );
}
```

## useThemeVariables

Get complete CSS variable set for theming.

```typescript
export function useThemeVariables(): React.CSSProperties {
  const theme = useTheme();

  const light: React.CSSProperties = {
    '--bg-primary': '#ffffff',
    '--bg-secondary': '#f1f5f9',
    '--bg-tertiary': '#e2e8f0',
    '--text-primary': '#0f172a',
    '--text-secondary': '#475569',
    '--text-tertiary': '#64748b',
    '--accent': '#0891b2',
    '--accent-light': '#e0f2fe',
    '--border': '#cbd5e1',
    '--success': '#10b981',
    '--warning': '#f59e0b',
    '--error': '#ef4444',
  } as React.CSSProperties;

  const dark: React.CSSProperties = {
    '--bg-primary': '#0b1120',
    '--bg-secondary': '#0f172a',
    '--bg-tertiary': '#1e293b',
    '--text-primary': '#f8fafc',
    '--text-secondary': '#e2e8f0',
    '--text-tertiary': '#94a3b8',
    '--accent': '#06b6d4',
    '--accent-light': 'rgba(6, 182, 212, 0.15)',
    '--border': '#334155',
    '--success': '#34d399',
    '--warning': '#fbbf24',
    '--error': '#f87171',
  } as React.CSSProperties;

  return theme === 'dark' ? dark : light;
}
```

**Usage**:
```typescript
function Widget() {
  const vars = useThemeVariables();

  return (
    <div style={{ ...vars, backgroundColor: 'var(--bg-primary)' }}>
      <p style={{ color: 'var(--text-primary)' }}>Text</p>
      <button style={{ background: 'var(--accent)' }}>Action</button>
    </div>
  );
}
```

## useWidgetState

Persist and restore widget state across conversation turns.

```typescript
import { useState, useCallback, useEffect, SetStateAction } from 'react';

export interface WidgetState {
  [key: string]: unknown;
}

export function useWidgetState<T extends WidgetState>(
  defaultState?: T | (() => T | null) | null
): readonly [T | null, (state: SetStateAction<T | null>) => void] {
  const initialState = window.openai?.widgetState as T | undefined;

  const [state, _setState] = useState<T | null>(() => {
    if (initialState) return initialState as T;
    if (typeof defaultState === 'function') return defaultState();
    return defaultState ?? null;
  });

  // Sync from window.openai when it changes
  useEffect(() => {
    const handler = () => {
      const newState = window.openai?.widgetState as T | undefined;
      if (newState) _setState(newState);
    };
    window.addEventListener('openai:set_globals', handler);
    return () => window.removeEventListener('openai:set_globals', handler);
  }, []);

  const setState = useCallback((action: SetStateAction<T | null>) => {
    _setState((prev) => {
      const next = typeof action === 'function' ? action(prev) : action;
      if (next) {
        window.openai?.setWidgetState(next);
      }
      return next;
    });
  }, []);

  return [state, setState] as const;
}
```

**Usage**:
```typescript
interface QuizState extends WidgetState {
  answers: Record<string, number>;
  submitted: boolean;
}

function QuizWidget() {
  const [state, setState] = useWidgetState<QuizState>(() => ({
    answers: {},
    submitted: false,
  }));

  const selectAnswer = (questionId: string, answerIndex: number) => {
    setState(prev => ({
      ...prev!,
      answers: { ...prev!.answers, [questionId]: answerIndex }
    }));
  };

  // State persists across conversation turns
}
```

## useCallTool

Invoke MCP tools from widget.

```typescript
export function useCallTool() {
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<Error | null>(null);

  const callTool = useCallback(async <T = unknown>(
    name: string,
    args: Record<string, unknown>
  ): Promise<T | undefined> => {
    setLoading(true);
    setError(null);

    try {
      const result = await window.openai?.callTool(name, args);
      return result?.structuredContent as T | undefined;
    } catch (e) {
      setError(e instanceof Error ? e : new Error(String(e)));
      return undefined;
    } finally {
      setLoading(false);
    }
  }, []);

  return { callTool, loading, error };
}
```

**Usage**:
```typescript
function SubmitButton() {
  const { callTool, loading, error } = useCallTool();

  const handleSubmit = async () => {
    const result = await callTool<{ score: number }>('submit_quiz', {
      answers: { q1: 0, q2: 1 }
    });
    if (result) {
      console.log('Score:', result.score);
    }
  };

  return (
    <button onClick={handleSubmit} disabled={loading}>
      {loading ? 'Submitting...' : 'Submit'}
    </button>
  );
}
```

## useDisplayMode

Access and change display mode.

```typescript
export function useDisplayMode() {
  const [mode, setMode] = useState<'inline' | 'fullscreen' | 'pip'>(
    () => window.openai?.displayMode ?? 'inline'
  );

  useEffect(() => {
    const handler = () => {
      setMode(window.openai?.displayMode ?? 'inline');
    };
    window.addEventListener('openai:set_globals', handler);
    return () => window.removeEventListener('openai:set_globals', handler);
  }, []);

  const requestMode = useCallback(async (
    newMode: 'inline' | 'fullscreen' | 'pip'
  ) => {
    await window.openai?.requestDisplayMode({ mode: newMode });
  }, []);

  return { mode, requestMode };
}
```

**Usage**:
```typescript
function ExpandButton() {
  const { mode, requestMode } = useDisplayMode();

  return (
    <button onClick={() => requestMode(mode === 'inline' ? 'fullscreen' : 'inline')}>
      {mode === 'inline' ? 'Expand' : 'Minimize'}
    </button>
  );
}
```

## Complete Hook Set Export

```typescript
// hooks/index.ts
export { useToolOutput } from './useToolOutput';
export { useToolMeta } from './useToolMeta';
export { useTheme, useThemeVariables, type Theme } from './useTheme';
export { useWidgetState, type WidgetState } from './useWidgetState';
export { useCallTool } from './useCallTool';
export { useDisplayMode } from './useDisplayMode';
```
