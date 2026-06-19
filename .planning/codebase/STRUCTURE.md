<!-- refreshed: 2026-06-19; verified against alicentra/SillyTavern release branch -->
# Codebase Structure

**Analysis Date:** 2026-06-18
**Verified Against:** `alicentra/SillyTavern` `release` branch (checked 2026-06-19)

## Directory Layout

```text
SillyTavern/
├── .github/workflows/             # GitHub Actions workflows
├── server.js                       # Entry point (CLI parse + bootstrap)
├── package.json                    # Dependencies and scripts
├── webpack.config.js               # Frontend bundling config
├── src/                            # Server-side source code
│   ├── server-main.js              # Express app setup
│   ├── server-startup.js           # Router registration + HTTP listen
│   ├── users.js                    # Multi-user auth and data management
│   ├── util.js                     # Shared server utilities
│   ├── constants.js                # Server constants
│   ├── git/                        # Git helper modules
│   ├── endpoints/                  # REST API route handlers
│   │   ├── backends/               # AI provider proxy endpoints
│   │   └── *.js                    # Feature-specific routers
│   ├── middleware/                 # Express middleware
│   ├── tokenizers/                 # Tokenizer implementations
│   ├── vectors/                    # Vector/embedding utilities
│   ├── validator/                  # Request/URL validation helpers
│   ├── png/                        # PNG metadata read/write
│   ├── types/                      # JSDoc type definitions
│   └── electron/                   # Electron desktop app support
├── public/                         # Frontend (served statically)
│   ├── scripts/                    # JavaScript modules
│   │   ├── extensions/             # Client-side extension modules
│   │   ├── slash-commands/         # Slash command system
│   │   ├── autocomplete/           # Autocomplete UI
│   │   ├── macros/                 # Template macro system
│   │   ├── templates/              # HTML template files
│   │   └── util/                   # Frontend utility modules
│   ├── css/                        # Stylesheets
│   ├── lib/                        # Vendored third-party libraries
│   ├── img/                        # Static images
│   ├── locales/                    # i18n translation files
│   └── sounds/                     # Audio files
├── data/                           # Runtime user data (gitignored)
├── default/                        # Default/scaffold data
│   ├── content/                    # Default content packages
│   └── scaffold/                   # Initial user directory template
├── plugins/                        # Server-side plugin directory
├── docker/                         # Docker configuration
├── tests/                          # Test files
│   ├── frontend/                   # Frontend tests
│   └── util/                       # Utility tests
└── backups/                        # Backup storage
```

## Directory Purposes

**`src/endpoints/`:**
- Purpose: All server API route handlers
- Contains: One JS file per feature domain, each exporting an Express `router`
- Key files: `characters.js`, `chats.js`, `openai.js`, `settings.js`

**`src/endpoints/backends/`:**
- Purpose: AI provider API proxy handlers
- Contains: `chat-completions.js`, `text-completions.js`, `kobold.js`

**`src/middleware/`:**
- Purpose: Express middleware functions
- Contains: `basicAuth.js`, `whitelist.js`, `accessLogWriter.js`, `cacheBuster.js`, `corsProxy.js`, `hostWhitelist.js`, `userCss.js`, `validateFileName.js`, `webpack-serve.js`

**`public/scripts/`:**
- Purpose: Frontend application logic
- Contains: ES modules for chat, settings, AI backends, UI
- Key files: `openai.js`, `power-user.js`, `world-info.js`, `tags.js`

**`public/scripts/extensions/`:**
- Purpose: Modular optional features (client-side)
- Contains: Subdirectories with `index.js` per extension
- Key extensions: `tts/`, `stable-diffusion/`, `expressions/`, `memory/`, `vectors/`, `quick-reply/`

**`default/scaffold/`:**
- Purpose: Template for new user data directories
- Contains: Default settings, presets, characters

## Key File Locations

**Entry Points:**
- `server.js`: Node.js server entry
- `public/scripts/loader.js`: Frontend bootstrap
- `src/server-main.js`: Express app configuration

**Configuration:**
- `.github/workflows/`: CI, publish, and issue/PR automation workflows
- `package.json`: Dependencies, scripts
- `webpack.config.js`: Frontend build
- `src/command-line.js`: CLI argument parsing
- `src/config-init.js`: Config file (`config.yaml`) initialization

**Core Logic (Server):**
- `src/endpoints/characters.js`: Character CRUD
- `src/endpoints/chats.js`: Chat persistence
- `src/endpoints/backends/chat-completions.js`: OpenAI-compatible completions proxy
- `src/users.js`: User management, sessions, data dirs

**Core Logic (Frontend):**
- `public/scripts/openai.js`: OpenAI/chat-completions frontend
- `public/scripts/textgen-settings.js`: Text generation settings
- `public/scripts/world-info.js`: World/lore book system
- `public/scripts/group-chats.js`: Group chat logic
- `public/scripts/slash-commands.js`: Slash command entry

**Testing:**
- `tests/frontend/`: Frontend test files
- `tests/util/`: Utility tests

## Naming Conventions

**Files:**
- Kebab-case for all JS files: `server-main.js`, `chat-completions.js`
- Feature name matches endpoint path: `characters.js` serves `/api/characters/*`

**Directories:**
- lowercase, kebab-case: `slash-commands/`, `quick-reply/`

**Exports:**
- Server endpoints export `{ router }` (Express Router instance)
- Frontend modules use named ES module exports

## Where to Add New Code

**New AI Backend Provider:**
- Server endpoint: `src/endpoints/[provider].js` (export `router`)
- Register in: `src/server-startup.js` (import and `app.use`)
- Frontend settings: `public/scripts/[provider]-settings.js`

**New Server API Feature:**
- Create: `src/endpoints/[feature].js` with Express Router
- Register in: `src/server-startup.js`
- Frontend consumer: `public/scripts/[feature].js`

**New Client Extension:**
- Create directory: `public/scripts/extensions/[name]/`
- Add `index.js` with extension registration
- Manifest in extension metadata

**New Middleware:**
- Create: `src/middleware/[name].js`
- Apply in: `src/server-main.js`

**Utilities:**
- Server: Add to `src/util.js` or create new file in `src/`; validation helpers belong in `src/validator/` when applicable
- Frontend: Add to `public/scripts/utils.js` or `public/scripts/util/`

## Special Directories

**`data/`:**
- Purpose: Runtime user data (characters, chats, settings per user)
- Generated: Yes (at runtime)
- Committed: No (gitignored)

**`default/`:**
- Purpose: Default scaffold and content shipped with the app
- Generated: No
- Committed: Yes

**`plugins/`:**
- Purpose: Server-side plugin loading directory
- Generated: No (user-managed)
- Committed: Directory only (contents gitignored)

**`.github/workflows/`:**
- Purpose: GitHub Actions automation for Docker/NPM publishing, PR checks, and issue/PR management
- Generated: No
- Committed: Yes

**`public/lib/`:**
- Purpose: Vendored third-party frontend libraries
- Generated: No
- Committed: Yes

---

*Structure analysis: 2026-06-18*
