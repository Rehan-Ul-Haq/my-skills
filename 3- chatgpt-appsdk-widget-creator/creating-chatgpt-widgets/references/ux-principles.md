# UX Principles for ChatGPT Widgets

> **Official Source**: https://developers.openai.com/apps-sdk/concepts/ux-principles
>
> For latest updates, fetch from official documentation.

## Core Philosophy

Create experiences that leverage ChatGPT's conversational nature:

- **Conversational Leverage**: Actions work within chat flow
- **Native Fit**: Feels like part of ChatGPT, not a separate app
- **Composability**: Works with other apps and conversation context

---

## Five Key Principles

### 1. Extract, Don't Port

**Wrong**: Mirror your entire desktop application
**Right**: Identify atomic actions users need

```
❌ Bad:  Full project management dashboard in widget
✅ Good: "Add task" action + task list display
```

Expose only essential inputs and outputs so the model can confidently proceed.

### 2. Design for Conversational Entry

Users arrive mid-conversation with unclear intent. Support:
- Open-ended prompts
- Direct commands
- First-run guidance within chat

**Never assume** users started from your app's entry point.

### 3. Design for the ChatGPT Environment

Use UI sparingly to:
- Clarify actions
- Present structured results

**Don't build** standalone dashboards.

```
❌ Bad:  Widget with its own navigation, settings, help
✅ Good: Widget shows data, conversation handles navigation
```

### 4. Optimize for Conversation, Not Navigation

The model handles routing between features. Your job:
- Provide clear, well-typed actions
- Return concise responses (tables, lists, brief text)
- Include helpful follow-up suggestions

### 5. Embrace the Ecosystem

- Accept natural language input
- Personalize using conversation context
- Compose with other apps when beneficial

---

## What to Include

**Good Widget Content**:
- Structured data visualization
- Interactive controls for actions
- Clear status indicators
- Concise text labels

## What to Avoid

**Never Include**:
- ❌ Long-form content (let ChatGPT explain)
- ❌ Complex multi-step workflows in single widget
- ❌ Advertisements
- ❌ Sensitive information displays
- ❌ Duplicated ChatGPT functions (chat input, settings)

---

## Pre-Publication Checklist

Before shipping, verify:

- [ ] **Conversational Value**: Adds value beyond base ChatGPT?
- [ ] **Atomic Actions**: Actions focused and specific?
- [ ] **Helpful UI Only**: Every UI element necessary?
- [ ] **End-to-End in Chat**: Users complete tasks without leaving?
- [ ] **Performance**: Responses under 200ms?
- [ ] **Discoverable**: Clear what the widget does?
- [ ] **Platform Leverage**: Uses ChatGPT's strengths?

---

## Visual Design Rules

> **Official Source**: https://developers.openai.com/apps-sdk/concepts/ui-guidelines

### Color
- Use system-defined palettes for text, icons, spatial elements
- Reserve brand accent for logos, icons, primary buttons only
- Avoid custom gradients/patterns that disrupt minimal aesthetic

### Typography
- Inherit platform-native fonts (SF Pro iOS, Roboto Android)
- Apply partner styling only in content areas
- Limit font size variation; prefer body and body-small

```css
font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
```

### Spacing & Layout
- Use consistent system grid spacing
- Maintain proper padding (no edge-to-edge text)
- Clear hierarchy: headline → supporting text → CTA

### Iconography
- Use system icons or monochromatic outlined custom icons
- ChatGPT auto-appends logo and app name
- Enforce consistent aspect ratios

---

## Accessibility Requirements (Mandatory)

- **WCAG AA contrast**: 4.5:1 text, 3:1 UI components
- **Alt text**: All images
- **Text resizing**: Without layout breakage
- **Focus indicators**: For interactive elements
- **Keyboard navigation**: Full support

```css
/* Minimum contrast examples */
.text-primary { color: #0f172a; }   /* On white: 15.4:1 ✓ */
.text-secondary { color: #475569; } /* On white: 7.1:1 ✓ */

/* Focus indicators */
button:focus-visible {
  outline: 2px solid #0891b2;
  outline-offset: 2px;
}
```

---

## Inline Widget Rules

- **Max 2 actions** at bottom of card
- **No deep navigation**
- **No nested scrolling**
- **No duplicative inputs**
- Height expands to mobile viewport maximum

## Fullscreen Widget Rules

- ChatGPT composer stays overlaid
- Account for safe areas (notches, home indicators)
- Provide obvious exit/close mechanism
