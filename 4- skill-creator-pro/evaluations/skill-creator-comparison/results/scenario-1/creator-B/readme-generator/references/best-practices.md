# README Best Practices

## Do

- **Clear first sentence**: State what project does immediately
- **Runnable examples**: All code blocks should work if copied
- **Language tags**: Use ```python, ```bash, etc.
- **Visual hierarchy**: Headers, bullets, tables for scannability
- **Keep current**: Update when features change

## Don't (Anti-Patterns)

| Anti-Pattern | Problem | Fix |
|--------------|---------|-----|
| Wall of text | Unreadable | Use headers, bullets |
| Missing examples | Users can't start | Add quick start section |
| Outdated commands | Broken setup | Test installation steps |
| Exposed secrets | Security risk | Use placeholders: `YOUR_API_KEY` |
| Dead links | Frustration | Verify all URLs |
| Jargon overload | Excludes newcomers | Define terms or link to glossary |

## Security

Never include in README:
- API keys or tokens
- Passwords or credentials
- Internal URLs
- Personal information

Use placeholders:
```bash
export API_KEY=your_api_key_here
```

## Badges (Optional)

Common badges:
- Build status
- Version/release
- License
- Coverage

Keep minimal; too many badges = noise.
