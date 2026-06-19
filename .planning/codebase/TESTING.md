<!-- refreshed: 2026-06-19; verified against alicentra/SillyTavern release branch -->
# Testing Patterns

**Analysis Date:** 2026-06-18
**Verified Against:** `alicentra/SillyTavern` `release` branch (checked 2026-06-19)

## Test Framework

**Runner:**
- Jest 29.7.0 (unit tests)
- Playwright 1.56.1 (E2E tests)
- Config: `tests/jest.config.json`, `tests/playwright.config.js`

**Assertion Library:**
- Jest `expect` for unit tests
- Playwright `expect` for E2E tests

**Run Commands:**
```bash
cd tests && npm test          # Run all (unit + e2e)
cd tests && npm run test:unit # Unit tests only (Jest)
cd tests && npm run test:e2e  # E2E tests only (Playwright)
```

**Note:** Tests live in a separate `tests/` package with its own `package.json` and dependencies.

## Test File Organization

**Location:**
- All tests in `tests/` directory (separate from source)
- Unit tests: `tests/*.test.js`
- E2E tests: `tests/*.e2e.js`
- Utilities: `tests/util/`
- Frontend tests: `tests/frontend/`

**Naming:**
- Unit: `{module-name}.test.js` (e.g., `prompt-converters.test.js`, `util.test.js`)
- E2E: `{feature}.e2e.js` (e.g., `sample.e2e.js`)

## Test Structure

**Suite Organization:**
```javascript
import { describe, test, expect, jest, beforeAll } from '@jest/globals';

describe('featureName', () => {
    test('should do something specific', () => {
        expect(result).toBe(expected);
    });
});
```

**Patterns:**
- `afterEach(() => { jest.restoreAllMocks(); })` for cleanup
- `beforeAll` with dynamic imports when mocking modules
- Helper functions defined at top of test file (e.g., `createMockExpressResponse()`)

## Mocking

**Framework:** Jest (`jest.fn()`, `jest.unstable_mockModule()`)

**Patterns:**
```javascript
// Module mocking (ESM-compatible)
jest.unstable_mockModule('../src/util.js', () => ({
    getConfigValue: jest.fn((_key, defaultValue) => defaultValue),
    tryParse: (str) => { try { return JSON.parse(str); } catch { return undefined; } },
}));

// Then dynamic import after mock setup
let mod;
beforeAll(async () => {
    mod = await import('../src/prompt-converters.js');
});
```

**What to Mock:**
- Configuration utilities (`getConfigValue`)
- External dependencies

**What NOT to Mock:**
- The module under test itself
- Pure utility functions being tested directly

## Fixtures and Factories

**Test Data:**
```javascript
// Helper factory functions in test files
function makeNames(charName = '', userName = '', groupNames = []) {
    return { charName, userName, groupNames, /* methods */ };
}

function createMockExpressResponse() {
    const response = new PassThrough();
    response.statusCode = 200;
    return response;
}
```

**Location:**
- Inline in test files (no shared fixtures directory)

## Coverage

**Requirements:** None enforced

**View Coverage:**
```bash
cd tests && npx jest --coverage
```

## Test Types

**Unit Tests:**
- Server-side logic (prompt converters, validators, utilities)
- Files: `tests/util.test.js`, `tests/prompt-converters.test.js`, `tests/tavern-card-validator.test.js`, `tests/util-pure.test.js`, `tests/private-request-filter.test.js`, `tests/mock-server.test.js`

**Integration Tests:**
- Not present as a distinct category

**E2E Tests:**
- Playwright against running server at `http://127.0.0.1:8000`
- File: `tests/sample.e2e.js`
- Config: 4 workers, fully parallel
- Screenshots/video on failure only

## Common Patterns

**Async Testing:**
```javascript
import { once } from 'node:events';

async function collectResponseBody(response) {
    const chunks = [];
    response.on('data', chunk => chunks.push(Buffer.from(chunk)));
    await once(response, 'finish');
    return Buffer.concat(chunks).toString('utf8');
}
```

**Error Testing:**
```javascript
test('should return the schema if it is not an object', () => {
    const schema = 'it is not an object';
    expect(flattenSchema(schema, CHAT_COMPLETION_SOURCES.MAKERSUITE)).toBe(schema);
});
```

## ESM Considerations

- Tests use `--experimental-vm-modules` flag for Jest ESM support
- Module mocking requires `jest.unstable_mockModule()` (not `jest.mock()`)
- Dynamic `import()` after mock setup is the standard pattern

---

*Testing analysis: 2026-06-18*
