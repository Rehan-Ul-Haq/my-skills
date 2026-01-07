/**
 * React Hooks for ChatGPT Widgets
 * Copy and use in your widget project
 */

import { useState, useEffect, useCallback, useSyncExternalStore } from 'react';

// ============================================
// Type Definitions
// ============================================

export type Theme = 'light' | 'dark';
export type DisplayMode = 'inline' | 'fullscreen' | 'pip';

export interface WidgetState {
  [key: string]: unknown;
}

// ============================================
// Event Constants
// ============================================

const SET_GLOBALS_EVENT = 'openai:set_globals';
const THEME_CHANGED_EVENT = 'openai:themeChanged';

// ============================================
// useToolOutput - Access MCP tool output
// ============================================

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

// ============================================
// useToolMeta - Access private _meta payload
// ============================================

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

// ============================================
// useTheme - React to theme changes
// ============================================

export function useTheme(): Theme {
  const [theme, setTheme] = useState<Theme>(
    () => (window.openai?.theme as Theme) ?? 'light'
  );

  useEffect(() => {
    const handler = () => {
      setTheme((window.openai?.theme as Theme) ?? 'light');
    };

    window.addEventListener(SET_GLOBALS_EVENT, handler);
    window.addEventListener(THEME_CHANGED_EVENT, handler);

    // Fallback to system preference
    const mq = window.matchMedia('(prefers-color-scheme: dark)');
    const mediaHandler = (e: MediaQueryListEvent) => {
      if (!window.openai?.theme) {
        setTheme(e.matches ? 'dark' : 'light');
      }
    };
    mq.addEventListener('change', mediaHandler);

    return () => {
      window.removeEventListener(SET_GLOBALS_EVENT, handler);
      window.removeEventListener(THEME_CHANGED_EVENT, handler);
      mq.removeEventListener('change', mediaHandler);
    };
  }, []);

  return theme;
}

// ============================================
// useThemeVariables - Get CSS variables
// ============================================

export interface ThemeVariables {
  '--bg-primary': string;
  '--bg-secondary': string;
  '--bg-tertiary': string;
  '--text-primary': string;
  '--text-secondary': string;
  '--text-tertiary': string;
  '--accent': string;
  '--accent-light': string;
  '--border': string;
  '--success': string;
  '--warning': string;
  '--error': string;
}

const lightTheme: ThemeVariables = {
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
};

const darkTheme: ThemeVariables = {
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
};

export function useThemeVariables(): ThemeVariables {
  const theme = useTheme();
  return theme === 'dark' ? darkTheme : lightTheme;
}

// ============================================
// useWidgetState - Persist widget state
// ============================================

type SetStateAction<T> = T | ((prev: T) => T);

export function useWidgetState<T extends WidgetState>(
  defaultState: T | (() => T)
): [T, (action: SetStateAction<T>) => void] {
  const [state, _setState] = useState<T>(() => {
    const saved = window.openai?.widgetState as T | undefined;
    if (saved) return saved;
    return typeof defaultState === 'function' ? defaultState() : defaultState;
  });

  // Sync from window.openai
  useEffect(() => {
    const handler = () => {
      const newState = window.openai?.widgetState as T | undefined;
      if (newState) _setState(newState);
    };
    window.addEventListener(SET_GLOBALS_EVENT, handler);
    return () => window.removeEventListener(SET_GLOBALS_EVENT, handler);
  }, []);

  const setState = useCallback((action: SetStateAction<T>) => {
    _setState((prev) => {
      const next = typeof action === 'function' ? (action as (p: T) => T)(prev) : action;
      window.openai?.setWidgetState(next);
      return next;
    });
  }, []);

  return [state, setState];
}

// ============================================
// useCallTool - Invoke MCP tools
// ============================================

interface CallToolResult<T> {
  callTool: (name: string, args: Record<string, unknown>) => Promise<T | undefined>;
  loading: boolean;
  error: Error | null;
}

export function useCallTool<T = unknown>(): CallToolResult<T> {
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<Error | null>(null);

  const callTool = useCallback(async (
    name: string,
    args: Record<string, unknown>
  ): Promise<T | undefined> => {
    setLoading(true);
    setError(null);

    try {
      const result = await window.openai?.callTool(name, args);
      return result?.structuredContent as T | undefined;
    } catch (e) {
      const err = e instanceof Error ? e : new Error(String(e));
      setError(err);
      return undefined;
    } finally {
      setLoading(false);
    }
  }, []);

  return { callTool, loading, error };
}

// ============================================
// useDisplayMode - Control display mode
// ============================================

interface DisplayModeResult {
  mode: DisplayMode;
  requestMode: (mode: DisplayMode) => Promise<void>;
  requestFullscreen: () => Promise<void>;
  requestInline: () => Promise<void>;
  close: () => void;
}

export function useDisplayMode(): DisplayModeResult {
  const [mode, setMode] = useState<DisplayMode>(
    () => (window.openai?.displayMode as DisplayMode) ?? 'inline'
  );

  useEffect(() => {
    const handler = () => {
      setMode((window.openai?.displayMode as DisplayMode) ?? 'inline');
    };
    window.addEventListener(SET_GLOBALS_EVENT, handler);
    return () => window.removeEventListener(SET_GLOBALS_EVENT, handler);
  }, []);

  const requestMode = useCallback(async (newMode: DisplayMode) => {
    await window.openai?.requestDisplayMode({ mode: newMode });
  }, []);

  const requestFullscreen = useCallback(async () => {
    await window.openai?.requestDisplayMode({ mode: 'fullscreen' });
  }, []);

  const requestInline = useCallback(async () => {
    await window.openai?.requestDisplayMode({ mode: 'inline' });
  }, []);

  const close = useCallback(() => {
    window.openai?.requestClose();
  }, []);

  return { mode, requestMode, requestFullscreen, requestInline, close };
}

// ============================================
// useSendMessage - Send follow-up messages
// ============================================

export function useSendMessage(): (prompt: string) => Promise<void> {
  return useCallback(async (prompt: string) => {
    await window.openai?.sendFollowUpMessage({ prompt });
  }, []);
}

// ============================================
// useLocale - Get user locale
// ============================================

export function useLocale(): string {
  const [locale, setLocale] = useState<string>(
    () => window.openai?.locale ?? 'en-US'
  );

  useEffect(() => {
    const handler = () => {
      setLocale(window.openai?.locale ?? 'en-US');
    };
    window.addEventListener(SET_GLOBALS_EVENT, handler);
    return () => window.removeEventListener(SET_GLOBALS_EVENT, handler);
  }, []);

  return locale;
}
