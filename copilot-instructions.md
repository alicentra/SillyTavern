# SillyTavern - GitHub Copilot Instructions

## Project Overview

**SillyTavern** is a locally installed user interface for interacting with:
- Text generation LLMs (Large Language Models)
- Image generation engines
- TTS (Text-to-Speech) voice models

**License**: AGPL-3.0  
**Repository**: https://github.com/SillyTavern/SillyTavern  
**Docs**: https://docs.sillytavern.app/  
**Primary Branch**: `staging` (most contributions target this branch)

## Technology Stack

### Backend
- **Runtime**: Node.js (ES modules)
- **Framework**: Express.js
- **Key Libraries**:
  - Image processing: @jimp/* (multiple plugins for various formats)
  - Tokenizers: @agnai/sentencepiece-js, @agnai/web-tokenizers
  - AI integrations: @zeldafan0225/ai_horde
  - Security: csrf-sync, cookie-session
  - Utilities: archiver, compression, cors, body-parser

### Frontend
- **Type**: JavaScript (browser-based)
- **Location**: `public/` directory
- **Libraries**: Located in `public/lib/`
- **i18n**: Translations in `public/locales/`

## Project Structure

### Backend (`src/`)
- `endpoints/` - API endpoints for various features
- `middleware/` - Express middleware functions
- `tokenizers/` - Text tokenization utilities
- `vectors/` - Vector operations for embeddings
- `validator/` - Input validation
- `electron/` - Electron desktop app support
- `png/` - PNG metadata handling
- `types/` - Type definitions
- `server-main.js` - Main server entry point
- `server-startup.js` - Server initialization
- `plugin-loader.js` - Plugin system loader
- `users.js` - User management
- `constants.js` - Application constants

### Frontend (`public/`)
- `scripts/` - Frontend JavaScript/modules
- `css/` - Stylesheets
- `locales/` - Internationalization files
- `lib/` - Third-party libraries
- `index.html` - Main application entry
- `login.html` - Login page

### Other Directories
- `plugins/` - Plugin system for extending functionality
- `data/` - Runtime data and cache
- `default/` - Default configuration files
- `tests/` - Test suite
- `docker/` - Docker configuration
- `backups/` - Chat backup files

## Coding Standards

### Code Quality
1. **Formatting**: Use VS Code's autoformat before committing
2. **Linting**: Run `npm run lint` and fix all errors
3. **Naming**: Follow existing naming conventions in the codebase
4. **Common Sense**: Keep code readable and maintainable

### Pull Request Guidelines
- **Target Branch**: `staging` for 99% of contributions
- **PR Size**: Keep under ~200 lines of code (additions + deletions) when possible
- **Testing**: Ensure changes are testable locally
- **Incremental**: Split large changes into multiple smaller PRs

### Exceptions for `release` Branch
Only target `release` for:
- README updates
- GitHub Actions updates
- Critical bug hotfixes

## Development Workflow

### Entry Points
- **Server**: `server.js` → imports `src/server-main.js`
- **Command Line**: Parsed via `src/command-line.js`
- **Data Root**: Set via `globalThis.DATA_ROOT`
- **Environment**: Check `process.env.NODE_ENV`

### Important Globals
- `globalThis.DATA_ROOT` - Root directory for data files
- `globalThis.COMMAND_LINE_ARGS` - Parsed CLI arguments
- `serverDirectory` - Base server directory

### Module System
- Uses **ES modules** (import/export syntax)
- Node.js environment variables set at startup
- Dynamic imports used for conditional loading

## Key Features to Understand

1. **Multi-LLM Support**: Supports various LLM backends and APIs
2. **Character Cards**: Character card parsing and management
3. **Chat System**: Chat history, backups, and recovery
4. **Plugin Architecture**: Extensible plugin system
5. **User Management**: Multi-user support with authentication
6. **Image Processing**: Character sprites, backgrounds, image generation
7. **Tokenization**: Multiple tokenizer backends for different models
8. **Vector Operations**: For embeddings and semantic search
9. **Proxy Support**: Request proxying for API calls
10. **Electron Desktop**: Can run as desktop application

## Common Patterns

### API Endpoints
- Located in `src/endpoints/`
- Use Express router patterns
- Include validation middleware
- Return JSON responses

### Configuration
- Central config in `config.yaml`
- Default configs in `default/`
- Runtime data in `data/`
- Command-line arguments override config

### Error Handling
- Use try-catch blocks
- Log errors appropriately
- Return meaningful error messages to client
- Handle async/await properly

### Security Considerations
- CSRF protection enabled
- Cookie-based sessions
- Input validation on all endpoints
- Sanitize user inputs (DOMPurify for HTML)

## Testing

- Test suite located in `tests/`
- Test locally before submitting PRs
- Ensure no regression in existing functionality
- Consider edge cases and error conditions

## Recommended Practices

1. **Read Existing Code**: Understand patterns before adding new features
2. **Consistent Style**: Match the existing code style
3. **Comments**: Add comments for complex logic
4. **Documentation**: Update docs if changing user-facing features
5. **Dependencies**: Be cautious adding new dependencies
6. **Backward Compatibility**: Avoid breaking existing functionality
7. **Performance**: Consider performance implications
8. **Security**: Always validate and sanitize user inputs

## Debugging Tips

- Check `server.js` startup logs for initialization errors
- Review endpoint definitions in `src/endpoints/`
- Examine middleware chain for request processing
- Look at browser console for frontend errors
- Check network tab for API communication issues

## Resources

- **Main Docs**: https://docs.sillytavern.app/
- **Discord Community**: https://discord.gg/sillytavern
- **Reddit**: https://reddit.com/r/SillyTavernAI
- **GitHub Issues**: For bug reports and feature requests

## Notes for AI Assistants

- This is a **chat/LLM interface application**, not an LLM itself
- Focus on **user interface** and **API integration** code
- Many features relate to **prompt engineering** and **character roleplay**
- The codebase serves both **web** and **desktop** (Electron) platforms
- **Plugin system** allows third-party extensions
- Be aware of **async operations** throughout the codebase
- **Security** is important - users run this locally with their API keys
