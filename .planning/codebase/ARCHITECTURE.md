<!-- refreshed: 2026-06-19; verified against alicentra/SillyTavern release branch -->
# Architecture

**Analysis Date:** 2026-06-18
**Verified Against:** `alicentra/SillyTavern` `release` branch (checked 2026-06-19)

## System Overview

```text
┌──────────────────────────────────────────────────────────────────┐
│                    Browser (SPA Frontend)                        │
│              `public/scripts/`, `public/css/`                    │
├─────────────────────┬───────────────────┬────────────────────────┤
│ Chat UI/UX          │ Extensions         │ AI Backend Clients    │
│ `public/scripts/`   │ `public/scripts/   │ `public/scripts/      │
│                     │  extensions/`      │  openai.js, nai-*.js` │
└─────────────────────┴───────────────────┴────────────────────────┘
          │                     │                    │
          ▼                     ▼                    ▼
┌──────────────────────────────────────────────────────────────────┐
│       Express.js HTTP Server (Node.js)                           │
│       `src/server-main.js` → `src/server-startup.js`             │
├─────────────────────────────┬────────────────────────────────────┤
│ Middleware Stack            │ API Route Endpoints                │
│ `src/middleware/`           │ `src/endpoints/`                   │
└─────────────────────────────┴────────────────────────────────────┘
          │
          ▼
┌──────────────────────────────────────────────────────────────────┐
│       Data Layer: Filesystem (JSON/JSONL files)                  │
│       `data/` (user data root, configurable via CLI)             │
└──────────────────────────────────────────────────────────────────┘
```

## Component Responsibilities

| Component | Responsibility | File |
|-----------|----------------|------|
| Server entry | CLI parsing, bootstrapping | `server.js` |
| Server main | Express app setup, middleware chain, listen | `src/server-main.js` |
| Server startup | Register all API routers, start HTTP(S) | `src/server-startup.js` |
| User management | Multi-user auth, session, data isolation | `src/users.js` |
| Endpoint routers | Domain-specific REST APIs (one per feature) | `src/endpoints/*.js` |
| Backend proxies | Forward requests to AI APIs (OpenAI, Anthropic, etc.) | `src/endpoints/backends/` |
| Frontend SPA | Chat interface, settings, character management | `public/scripts/` |
| Extensions (client) | Modular UI features (TTS, SD, memory, etc.) | `public/scripts/extensions/` |
| Plugin system (server) | Third-party server-side plugins | `plugins/`, `src/plugin-loader.js` |

## Pattern Overview

**Key Characteristics:**
- No frontend framework (vanilla JS with jQuery)
- Server acts as both static file host and API proxy to AI backends
- File-system based persistence (no database)
- Multi-user support with per-user data directories
- Extension system on both client and server sides

## Layers

**Presentation (Frontend):**
- Purpose: Chat UI, settings panels, character management
- Location: `public/scripts/`, `public/css/`
- Contains: Vanilla JS modules (ES modules via webpack), jQuery-based DOM manipulation
- Depends on: Server API endpoints
- Used by: End users via browser

**API Layer (Express Routers):**
- Purpose: REST endpoints for all features
- Location: `src/endpoints/`
- Contains: Express Router modules, each exporting a `router`
- Depends on: Middleware, utility functions, filesystem
- Used by: Frontend via fetch/AJAX

**Middleware:**
- Purpose: Auth, CSRF, whitelist/host whitelist, CORS proxy, logging, compression, response timing, user CSS, request filtering
- Location: `src/middleware/`
- Contains: Express middleware functions
- Depends on: Config, user system
- Used by: Express app pipeline

**Data/Storage:**
- Purpose: Persistent state (characters, chats, settings)
- Location: `data/` (runtime), `default/` (scaffolding)
- Contains: JSON files, JSONL chat logs, PNG character cards
- Depends on: Filesystem
- Used by: Endpoint routers

## Data Flow

### Primary Request Path (Chat Message)

1. User sends message in browser UI (`public/scripts/openai.js` or `public/scripts/textgen-settings.js`)
2. Frontend POSTs to server endpoint (e.g., `/api/backends/chat-completions/generate`)
3. Server middleware chain: CSRF check, auth, user data resolution (`src/server-main.js`)
4. Backend router forwards request to external AI API (`src/endpoints/backends/chat-completions.js`)
5. Response streamed back (SSE) or returned as JSON to frontend
6. Frontend renders response in chat DOM

### Character/Chat Persistence

1. Frontend calls `/api/characters/create` or `/api/chats/save`
2. Endpoint handler writes JSON/JSONL to user's data directory
3. Character cards stored as PNG with embedded metadata (`src/png/`)

**State Management:**
- Server: Stateless (per-request user resolution from session cookie)
- Frontend: Global JS state in module-level variables, localStorage

## Entry Points

**Server:**
- Location: `server.js`
- Triggers: `node server.js` or `npm start`
- Responsibilities: Parse CLI args, set globals, import `src/server-main.js`

**Frontend:**
- Location: `public/scripts/loader.js`
- Triggers: Browser loads `index.html`
- Responsibilities: Bootstrap the SPA, load extensions

## Key Abstractions

**Express Routers (one per domain):**
- Purpose: Isolate API logic per feature
- Examples: `src/endpoints/characters.js`, `src/endpoints/chats.js`, `src/endpoints/openai.js`
- Pattern: Each file exports `{ router }`, mounted in `src/server-startup.js`

**Extensions (client-side):**
- Purpose: Optional feature modules loaded dynamically
- Examples: `public/scripts/extensions/tts/`, `public/scripts/extensions/stable-diffusion/`
- Pattern: Each has `index.js`, registered via extension manifest

**Backends:**
- Purpose: Abstract different AI provider APIs
- Examples: `src/endpoints/backends/chat-completions.js`, `src/endpoints/backends/kobold.js`
- Pattern: Normalize request/response format between frontend and various AI APIs

## Architectural Constraints

- **Threading:** Single-threaded Node.js event loop; no worker threads
- **Global state:** `globalThis.DATA_ROOT` and `globalThis.COMMAND_LINE_ARGS` set at startup (`server.js`)
- **No database:** All persistence is filesystem JSON/JSONL; no migrations, no queries
- **Circular imports:** Not observed as significant issue due to flat router structure

## Anti-Patterns

### God Files in Frontend

**What happens:** Files like `public/scripts/openai.js` and `public/scripts/power-user.js` contain massive amounts of logic
**Why it's wrong:** Hard to navigate, test, or modify safely
**Do this instead:** Split by concern into smaller modules under `public/scripts/`

### No Frontend Framework

**What happens:** DOM manipulation via jQuery and vanilla JS with global state
**Why it's wrong:** Makes state management error-prone and testing difficult
**Do this instead:** This is a deliberate project choice for simplicity; follow existing patterns

## Error Handling

**Strategy:** Try/catch in endpoint handlers, log to console, return HTTP error codes

**Patterns:**
- Endpoints wrap handler bodies in try/catch, return 500 on unhandled errors
- Frontend shows toastr notifications on API errors

## Cross-Cutting Concerns

**Logging:** Console-based with chalk coloring (`src/util.js` - `color()`), plus response-time middleware in the Express stack
**Validation:** `src/validator/` for request validation
**Authentication:** Cookie-session with optional basic auth and user accounts (`src/users.js`)
**CSRF:** `csrf-sync` library applied globally unless disabled by CLI/config

---

*Architecture analysis: 2026-06-18*
