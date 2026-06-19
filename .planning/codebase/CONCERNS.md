<!-- refreshed: 2026-06-19; verified against alicentra/SillyTavern release branch -->
# Codebase Concerns

**Analysis Date:** 2026-06-18
**Verified Against:** `alicentra/SillyTavern` `release` branch (checked 2026-06-19)

## Tech Debt

**Monolithic Frontend Entry Point:**
- Issue: `public/script.js` is 12,560 lines with 442+ function definitions — a single god-file orchestrating the entire frontend
- Files: `public/script.js`
- Impact: Extremely difficult to maintain, high merge conflict risk, slow comprehension for new contributors
- Fix approach: Incrementally extract into feature modules under `public/scripts/`

**Massive Individual Script Files:**
- Issue: Multiple frontend scripts exceed 2000–7000 lines each
- Files: `public/scripts/openai.js` (7249), `public/scripts/slash-commands.js` (7095), `public/scripts/world-info.js` (6289), `public/scripts/stable-diffusion/index.js` (5998), `public/scripts/power-user.js` (4460)
- Impact: Cognitive overload, hard to test individual behaviors, tight coupling within files
- Fix approach: Split by responsibility; extract classes/modules for distinct features

**Duplicated Code Between Client and Server:**
- Issue: Constants and logic copied between frontend and backend with acknowledged TODO
- Files: `src/constants.js:221` ("TODO: this is copied from the client code; there should be a way to de-duplicate it eventually")
- Impact: Drift between client/server definitions, double maintenance burden
- Fix approach: Create shared module consumable by both environments (webpack alias or shared package)

**jQuery Dependency:**
- Issue: Heavy reliance on jQuery 3.5.1 and jQuery UI for DOM manipulation across the entire frontend
- Files: `public/lib/jquery-3.5.1.min.js`, `public/lib/jquery-ui.min.js`, throughout `public/scripts/`
- Impact: Prevents modern framework adoption, performance overhead, mixing paradigms
- Fix approach: Gradual migration to vanilla DOM APIs or a lightweight reactive framework

**Deprecated APIs Still In Use:**
- Issue: Multiple deprecated internal APIs remain (`renderExtensionTemplate`, `/qrset` command, `hideChatMessage`), plus heavy use of `document.execCommand`
- Files: `public/scripts/extensions.js:123`, `public/scripts/chats.js:173-184`, `public/scripts/extensions/quick-reply/src/QuickReply.js` (multiple uses)
- Impact: Future breakage as browsers remove deprecated features; confusing API surface
- Fix approach: Remove deprecated shims after migration period; replace `execCommand` with Clipboard/Input Event APIs

## Security Considerations

**innerHTML Usage Throughout Frontend:**
- Risk: 103 uses of `innerHTML` across frontend scripts, plus 23 uses of jQuery `.html()` — potential XSS vectors
- Files: Spread across `public/scripts/` (103 occurrences)
- Current mitigation: DOMPurify (`dompurify` in dependencies) is available but unclear if consistently applied
- Recommendations: Audit all innerHTML assignments for user-controlled input; enforce DOMPurify wrapper; add CSP headers

**Path Traversal Surface:**
- Risk: Many endpoints construct file paths from user input via `path.join` with request body values
- Files: `src/endpoints/assets.js`, `src/endpoints/backgrounds.js`, `src/endpoints/backups.js`, `src/endpoints/characters.js`
- Current mitigation: `sanitize()` is used in many (but not all) path constructions
- Recommendations: Audit all `path.join` calls that use `request.body.*` or `request.params.*`, ensure consistent sanitization; add path-contains-base validation

**Extension System Trust Model:**
- Risk: Third-party extensions loaded with full DOM/API access
- Files: `public/scripts/extensions.js` (2315 lines), `src/endpoints/extensions.js` (515 lines)
- Current mitigation: CSRF protection via `csrf-sync`, `helmet` headers
- Recommendations: Consider sandboxing extensions or implementing a permission model

## Performance Bottlenecks

**Large Monolithic Frontend Load:**
- Problem: All scripts loaded upfront; `public/script.js` alone is 12K+ lines
- Files: `public/script.js`, `public/scripts/` (entire directory)
- Cause: No code splitting, no lazy loading of features
- Improvement path: Webpack is configured (`webpack.config.js` exists) — implement dynamic imports for extensions and infrequently-used features

**Backend Endpoint File Sizes:**
- Problem: `src/endpoints/backends/chat-completions.js` (2896 lines), `src/endpoints/stable-diffusion.js` (2208 lines) are monolithic
- Files: `src/endpoints/backends/chat-completions.js`, `src/endpoints/stable-diffusion.js`
- Cause: All provider logic in single files rather than strategy pattern
- Improvement path: Extract per-provider handlers into separate modules

## Fragile Areas

**Chat Completions Endpoint:**
- Files: `src/endpoints/backends/chat-completions.js` (2896 lines)
- Why fragile: Handles multiple AI providers (Claude, OpenAI, etc.) in one file with branching logic
- Safe modification: Test with multiple providers after any change; consider provider-specific modules
- Test coverage: Minimal (only ~6 test files exist for entire backend)

**Slash Command System:**
- Files: `public/scripts/slash-commands.js` (7095 lines)
- Why fragile: Complex parser with many registered commands; tightly coupled to chat state
- Safe modification: Use the autocomplete tests as regression checks
- Test coverage: No dedicated unit tests found

**World Info / Lorebook:**
- Files: `public/scripts/world-info.js` (6289 lines)
- Why fragile: Complex matching logic, recursive scanning, performance-sensitive
- Safe modification: Changes to matching algorithm affect all users' lorebooks
- Test coverage: None detected

## Test Coverage Gaps

**Extremely Low Backend Test Coverage:**
- What's not tested: Only 6 test files exist for 47 endpoint files and numerous utility modules
- Files: `tests/mock-server.test.js`, `tests/private-request-filter.test.js`, `tests/prompt-converters.test.js`, `tests/tavern-card-validator.test.js`, `tests/util-pure.test.js`, `tests/util.test.js`
- Risk: Regressions in API endpoints, file handling, authentication, and proxy logic go undetected
- Priority: High

**No Frontend Unit Tests:**
- What's not tested: Entire `public/scripts/` directory (7000+ line files) has no unit test coverage
- Files: `public/scripts/` (all files)
- Risk: UI logic, slash commands, world-info matching, chat rendering — all untested
- Priority: High

**E2E Tests Minimal:**
- What's not tested: Only `tests/sample.e2e.js` exists with Playwright config
- Files: `tests/sample.e2e.js`, `tests/playwright.config.js`
- Risk: No automated verification of user workflows
- Priority: Medium

## Dependencies at Risk

**jQuery 3.5.1 (Outdated):**
- Risk: Known security patches in newer versions; locked to old version
- Impact: XSS vulnerabilities in jQuery selector parsing
- Migration plan: Update to latest jQuery 3.x as interim; long-term move away from jQuery

**Large Dependency Count:**
- Risk: 60+ production dependencies increases supply-chain attack surface
- Impact: Any compromised dependency gets full server access
- Migration plan: Audit with `npm audit`; consider reducing dependency count for critical paths

## Missing Critical Features

**Structured Logging:**
- Problem: All logging via `console.log` / `console.error` with no structured format
- Blocks: Log aggregation, filtering, alerting in production deployments

**Rate Limiting:**
- Problem: `rate-limiter-flexible` is installed, but no global API rate-limiting middleware is visible in the main Express middleware chain
- Blocks: Protection against abuse when exposed to network unless individual endpoints add their own controls

---

*Concerns audit: 2026-06-18*
