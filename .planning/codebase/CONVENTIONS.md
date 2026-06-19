<!-- refreshed: 2026-06-19; verified against alicentra/SillyTavern release branch -->
# Coding Conventions

**Analysis Date:** 2026-06-18
**Verified Against:** `alicentra/SillyTavern` `release` branch (checked 2026-06-19)

## Naming Patterns

**Files:**
- kebab-case for server files: `src/prompt-converters.js`, `src/character-card-parser.js`
- PascalCase for browser-side class-oriented files: `public/scripts/extensions/quick-reply/src/QuickReplySet.js`, `QuickReply.js`, `ButtonUi.js`
- kebab-case remains common for feature directories and server/API files

**Functions:**
- camelCase: `getConfigValue`, `humanizedDateTime`, `tryParse`, `forwardFetchResponse`

**Variables:**
- camelCase: `memoryCacheCapacity`, `isAndroid`, `useShallowCharacters`
- UPPER_SNAKE for constants: `AVATAR_WIDTH`, `AVATAR_HEIGHT`, `DEFAULT_AVATAR_PATH`, `CHAT_COMPLETION_SOURCES`

**Types:**
- PascalCase classes: `DiskCache`, `TavernCardValidator`, `ByafParser`, `CharXParser`
- JSDoc for type annotations (no TypeScript)

## Code Style

**Formatting:**
- ESLint enforced (no Prettier)
- Config: `.eslintrc.cjs`
- Run: `npm run lint` / `npm run lint:fix`

**Key Rules (from `.eslintrc.cjs`):**
- Single quotes (enforced)
- Semicolons always (enforced)
- 4-space indentation
- Trailing commas on multiline (`comma-dangle: always-multiline`)
- Object curly spacing: `{ like: this }`
- 1TBS brace style
- No trailing spaces
- File ends with newline (`eol-last`)
- Named functions: no space before parens; anonymous/async arrow: space before parens

**Linting:**
- ESLint with `eslint:recommended` base
- Plugin: `eslint-plugin-jsdoc`
- Separate lint configs for server (`src/`) and browser (`public/`) code

## Import Organization

**Order (server-side):**
1. Node built-ins: `import path from 'node:path'`
2. Third-party packages: `import express from 'express'`
3. Local modules: `import { deepMerge } from '../util.js'`

**Path style:**
- Always include `.js` extension in imports (ESM)
- Use `node:` prefix for Node.js built-ins

**Path Aliases:**
- None — relative paths throughout

## Error Handling

**Patterns:**
- try/catch with console logging for endpoint handlers
- `tryParse()` utility for safe JSON parsing (returns `undefined` on failure)
- Express middleware pattern for validation (`validateAvatarUrlMiddleware`)

## Logging

**Framework:** console (raw)

**Patterns:**
- Server: `console.log`, `console.error`, `console.warn`
- Browser extensions use prefixed loggers: `console.debug('[QR2]', ...msg)`
- No structured logging framework

## Comments

**When to Comment:**
- JSDoc on classes and exported functions
- Inline comments for non-obvious logic
- `// TODO`, `// FIXME` for known issues

**JSDoc:**
- Used extensively for type annotations (since codebase is plain JS, not TypeScript)
- `/** @type {Type} */` before variable declarations
- `@param`, `@returns` on exported functions

## Function Design

**Size:** No enforced limit; some files are large (monolithic endpoint handlers)

**Parameters:** Typically use object destructuring for complex params; simple positional args for utilities

**Return Values:** Direct returns; utilities return `undefined` / `null` on failure rather than throwing

## Module Design

**Exports:**
- Server: ES module named exports (`export function`, `export default`)
- Browser: ES module imports/exports throughout `public/scripts/`

**Barrel Files:** Not used — import directly from source files

## Language

**Primary:** JavaScript (ES2022+, ESM)
- No TypeScript compilation
- JSDoc used for type information
- `jsconfig.json` present for IDE support

---

*Convention analysis: 2026-06-18*
