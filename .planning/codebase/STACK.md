<!-- refreshed: 2026-06-19; verified against alicentra/SillyTavern release branch -->
# Technology Stack

**Analysis Date:** 2026-06-18
**Verified Against:** `alicentra/SillyTavern` `release` branch (checked 2026-06-19)

## Languages

**Primary:**
- JavaScript (ES Modules) - Server and client code throughout

**Secondary:**
- HTML/CSS - Frontend UI in `public/`

## Runtime

**Environment:**
- Node.js >= 20 (also supports Deno and Bun via alternate start scripts)

**Package Manager:**
- npm
- Lockfile: `package-lock.json` present

## Frameworks

**Core:**
- Express ^4.21.0 - HTTP server framework (`src/server-main.js`)

**Testing:**
- Not detected in dependencies (no jest/vitest/mocha in package.json)

**Build/Dev:**
- Webpack ^5.105.4 - Client-side bundling (`webpack.config.js`)
- ESLint - Linting (`npm run lint`)

## Key Dependencies

**Critical:**
- `express` ^4.21.0 - Core web server
- `ws` ^8.18.3 - WebSocket support for real-time features
- `tiktoken` ^1.0.22 - Token counting for LLM context
- `sillytavern-transformers` 2.14.6 - ML model tokenizers
- `node-fetch` ^3.3.2 - HTTP client for API calls
- `isomorphic-git` ^1.36.3 - Git operations for chat history

**Infrastructure:**
- `helmet` ^8.1.0 - Security headers
- `csrf-sync` ^4.2.1 - CSRF protection
- `cookie-session` ^2.1.1 - Session management
- `multer` ^2.1.1 - File upload handling
- `compression` ^1.8.1 - Response compression
- `rate-limiter-flexible` ^5.0.5 - Rate-limiting library present (not visibly applied as global middleware)
- `proxy-agent` ^6.5.0 - Proxy support for outbound requests

**Image Processing:**
- `@jimp/*` ^1.6.0 - Server-side image manipulation (multiple plugins)

**Data/Storage:**
- `node-persist` ^4.0.4 - File-based key-value storage
- `vectra` ^0.2.2 - Local vector database for RAG
- `localforage` ^1.10.0 - Client-side storage

**Translation:**
- `google-translate-api-x` ^10.7.2
- `bing-translate-api` ^4.1.0

**Frontend (bundled/vendored):**
- jQuery 3.5.1 and jQuery UI are vendored in `public/lib/`; `@types/jquery` is present in devDeps
- Handlebars ^4.7.9 - Templating
- highlight.js ^11.11.1 - Code highlighting
- DOMPurify ^3.4.2 - XSS prevention
- Fuse.js ^7.1.0 - Fuzzy search

## Configuration

**Environment:**
- `config.yaml` - Main server configuration (parsed at startup via `src/config-init.js`)
- `secrets.json` - API keys stored per-user (`src/endpoints/secrets.js`)
- CLI arguments parsed in `src/command-line.js`

**Build:**
- `webpack.config.js` - Client bundle configuration

## Platform Requirements

**Development:**
- Node.js >= 20
- npm for dependency management
- Optional: Deno or Bun as alternative runtimes

**Production:**
- Self-hosted (no cloud deployment target)
- Docker support available (`docker/` directory)
- Electron packaging available (`src/electron/`)

---

*Stack analysis: 2026-06-18*
