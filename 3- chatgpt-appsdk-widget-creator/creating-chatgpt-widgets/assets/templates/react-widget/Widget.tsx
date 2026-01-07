/**
 * ChatGPT Widget Template - React/TypeScript
 *
 * Replace [WidgetName] with your widget name
 * Replace [DataType] with your data interface
 */

import React, { useState, useEffect, useSyncExternalStore, useCallback } from 'react';

// ============================================
// Type Definitions
// ============================================

interface OpenAiGlobal {
  toolOutput?: Record<string, unknown>;
  toolInput?: Record<string, unknown>;
  toolResponseMetadata?: Record<string, unknown>;
  widgetState?: Record<string, unknown>;
  theme?: 'light' | 'dark';
  displayMode?: 'inline' | 'fullscreen' | 'pip';
  maxHeight?: number;
  locale?: string;
  setWidgetState: (state: Record<string, unknown>) => void;
  callTool: (name: string, args: Record<string, unknown>) => Promise<{
    structuredContent?: Record<string, unknown>;
  }>;
  sendFollowUpMessage: (options: { prompt: string }) => Promise<void>;
  requestDisplayMode: (options: { mode: string }) => Promise<void>;
  requestClose: () => void;
}

declare global {
  interface Window {
    openai?: OpenAiGlobal;
  }
}

// Replace with your data structure
interface WidgetData {
  title: string;
  items: Array<{
    id: string;
    name: string;
    description?: string;
  }>;
}

interface WidgetState {
  selectedId?: string;
  expanded?: boolean;
}

// ============================================
// Hooks
// ============================================

const SET_GLOBALS_EVENT = 'openai:set_globals';

function useToolOutput<T>(): T | undefined {
  return useSyncExternalStore(
    (onChange) => {
      window.addEventListener(SET_GLOBALS_EVENT, onChange);
      return () => window.removeEventListener(SET_GLOBALS_EVENT, onChange);
    },
    () => window.openai?.toolOutput as T | undefined,
    () => undefined
  );
}

function useTheme(): 'light' | 'dark' {
  const [theme, setTheme] = useState<'light' | 'dark'>(
    () => window.openai?.theme ?? 'light'
  );

  useEffect(() => {
    const handler = () => setTheme(window.openai?.theme ?? 'light');
    window.addEventListener(SET_GLOBALS_EVENT, handler);
    window.addEventListener('openai:themeChanged', handler);
    return () => {
      window.removeEventListener(SET_GLOBALS_EVENT, handler);
      window.removeEventListener('openai:themeChanged', handler);
    };
  }, []);

  return theme;
}

function useWidgetState<T extends Record<string, unknown>>(
  defaultState: T
): [T, (update: Partial<T> | ((prev: T) => T)) => void] {
  const [state, _setState] = useState<T>(() => {
    const saved = window.openai?.widgetState as T | undefined;
    return saved ?? defaultState;
  });

  useEffect(() => {
    const handler = () => {
      const newState = window.openai?.widgetState as T | undefined;
      if (newState) _setState(newState);
    };
    window.addEventListener(SET_GLOBALS_EVENT, handler);
    return () => window.removeEventListener(SET_GLOBALS_EVENT, handler);
  }, []);

  const setState = useCallback((update: Partial<T> | ((prev: T) => T)) => {
    _setState((prev) => {
      const next = typeof update === 'function' ? update(prev) : { ...prev, ...update };
      window.openai?.setWidgetState(next);
      return next;
    });
  }, []);

  return [state, setState];
}

// ============================================
// Theme System
// ============================================

const themes = {
  light: {
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
  },
  dark: {
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
  },
} as const;

// ============================================
// Components
// ============================================

function Loading(): React.ReactElement {
  return (
    <div style={{
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'center',
      minHeight: '200px',
      color: 'var(--text-tertiary)',
    }}>
      <div style={{
        width: '24px',
        height: '24px',
        border: '3px solid var(--border)',
        borderTopColor: 'var(--accent)',
        borderRadius: '50%',
        animation: 'spin 1s linear infinite',
      }} />
      <style>{`@keyframes spin { to { transform: rotate(360deg); } }`}</style>
    </div>
  );
}

function Error({ message }: { message: string }): React.ReactElement {
  return (
    <div style={{
      padding: '16px',
      background: 'rgba(239, 68, 68, 0.1)',
      border: '1px solid var(--error)',
      borderRadius: '8px',
      color: 'var(--error)',
    }}>
      {message}
    </div>
  );
}

function Empty(): React.ReactElement {
  return (
    <div style={{
      textAlign: 'center',
      padding: '32px',
      color: 'var(--text-tertiary)',
    }}>
      No data available
    </div>
  );
}

interface CardProps {
  title: string;
  description?: string;
  selected?: boolean;
  onClick?: () => void;
}

function Card({ title, description, selected, onClick }: CardProps): React.ReactElement {
  return (
    <div
      onClick={onClick}
      style={{
        background: selected ? 'var(--accent-light)' : 'var(--bg-secondary)',
        border: `1px solid ${selected ? 'var(--accent)' : 'var(--border)'}`,
        borderRadius: '12px',
        padding: '16px',
        marginBottom: '12px',
        cursor: onClick ? 'pointer' : 'default',
        transition: 'all 0.15s ease',
      }}
    >
      <h3 style={{
        fontSize: '1.0625rem',
        fontWeight: 600,
        color: 'var(--text-primary)',
        margin: '0 0 4px 0',
      }}>
        {title}
      </h3>
      {description && (
        <p style={{
          fontSize: '0.9375rem',
          color: 'var(--text-secondary)',
          margin: 0,
        }}>
          {description}
        </p>
      )}
    </div>
  );
}

interface ButtonProps {
  children: React.ReactNode;
  variant?: 'primary' | 'secondary';
  disabled?: boolean;
  onClick?: () => void;
}

function Button({ children, variant = 'primary', disabled, onClick }: ButtonProps): React.ReactElement {
  return (
    <button
      onClick={onClick}
      disabled={disabled}
      style={{
        display: 'inline-flex',
        alignItems: 'center',
        justifyContent: 'center',
        gap: '8px',
        padding: '10px 20px',
        fontSize: '0.9375rem',
        fontWeight: 600,
        border: 'none',
        borderRadius: '8px',
        cursor: disabled ? 'not-allowed' : 'pointer',
        transition: 'all 0.15s ease',
        background: variant === 'primary' ? 'var(--accent)' : 'var(--bg-tertiary)',
        color: variant === 'primary' ? 'white' : 'var(--text-primary)',
        opacity: disabled ? 0.5 : 1,
      }}
    >
      {children}
    </button>
  );
}

// ============================================
// Main Widget
// ============================================

export function Widget(): React.ReactElement {
  const theme = useTheme();
  const data = useToolOutput<WidgetData>();
  const [state, setState] = useWidgetState<WidgetState>({});
  const [loading, setLoading] = useState(false);

  const themeVars = themes[theme];

  // Handle item selection
  const handleSelect = (id: string) => {
    setState({ selectedId: state.selectedId === id ? undefined : id });
  };

  // Handle action (calls MCP tool)
  const handleAction = async () => {
    if (!state.selectedId) return;

    setLoading(true);
    try {
      const result = await window.openai?.callTool('your_tool_name', {
        itemId: state.selectedId,
      });
      console.log('Tool result:', result?.structuredContent);
    } catch (error) {
      console.error('Action failed:', error);
    } finally {
      setLoading(false);
    }
  };

  // Handle follow-up message
  const handleFollowUp = async () => {
    await window.openai?.sendFollowUpMessage({
      prompt: 'Tell me more about this',
    });
  };

  // Render
  return (
    <div style={{
      ...themeVars as React.CSSProperties,
      backgroundColor: 'var(--bg-primary)',
      color: 'var(--text-primary)',
      fontFamily: '-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif',
      padding: '16px',
      minHeight: '100%',
    }}>
      {/* Loading State */}
      {!data && <Loading />}

      {/* Error State */}
      {data && (data as any).isError && (
        <Error message={(data as any).message || 'An error occurred'} />
      )}

      {/* Empty State */}
      {data && !data.items?.length && <Empty />}

      {/* Main Content */}
      {data && data.items?.length > 0 && (
        <>
          {/* Header */}
          <h2 style={{
            fontSize: '1.25rem',
            fontWeight: 700,
            color: 'var(--text-primary)',
            margin: '0 0 16px 0',
          }}>
            {data.title || 'Widget Title'}
          </h2>

          {/* Item List */}
          {data.items.map((item) => (
            <Card
              key={item.id}
              title={item.name}
              description={item.description}
              selected={state.selectedId === item.id}
              onClick={() => handleSelect(item.id)}
            />
          ))}

          {/* Actions */}
          <div style={{ display: 'flex', gap: '12px', marginTop: '16px' }}>
            <Button
              onClick={handleAction}
              disabled={!state.selectedId || loading}
            >
              {loading ? 'Processing...' : 'Take Action'}
            </Button>
            <Button variant="secondary" onClick={handleFollowUp}>
              Ask More
            </Button>
          </div>
        </>
      )}
    </div>
  );
}

export default Widget;
