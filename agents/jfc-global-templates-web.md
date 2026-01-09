# Repository Guidelines

## Project Structure & Module Organization
- Monorepo managed by Turborepo; top-level packages live in `packages/*`.
- App template (Next.js) lives in `packages/jfc-global-template/template` and is published as `@jollibee-foods-corporation/__brand_name__-web`.
- Shared libraries (auth, config, state, sdk, ecommerce, ui) are under `packages/jfc-global-*`.
- Storybook workspace is in `packages/jfc-global-storybook`.
- Scripts are in `scripts/` and template-specific scripts in `packages/jfc-global-template/template/scripts/`.
- Tests typically live next to source files with `*.test.ts`/`*.test.tsx`; Cypress e2e specs are in `packages/jfc-global-template/template/cypress/e2e`.

## Build, Test, and Development Commands
- `npm run dev` (root): run all package dev servers via Turbo.
- `npm run dev:app` (root): run only the template app package.
- `npm run build`: build all packages except Storybook.
- `npm run lint` / `npm run lint:fix`: run ESLint + Stylelint across packages.
- `npm run test`: run package/unit tests via Turbo.
- `npm run test:ui`: run Cypress e2e tests.
- Template app (in `packages/jfc-global-template/template`): `npm run dev`, `npm run build`, `npm run test`, `npm run test:coverage`.

## Coding Style & Naming Conventions
- Indentation: 2 spaces for JS/TS/JSON/SCSS.
- Language preferences: TypeScript/TSX for app and library code; SCSS for styles.
- Linting: ESLint and Stylelint are enforced; prefer running `npm run lint` before pushing.
- Naming: packages follow `jfc-global-*`; tests `*.test.ts(x)`; Storybook stories `*.stories.tsx`.

## Testing Guidelines
- Unit tests: Vitest in most packages (`vitest.config.mjs`); Jest in the template app (`jest.config.mjs`).
- E2E: Cypress in the template app (`cypress/e2e`).
- Keep tests colocated with code and use descriptive test names tied to feature behavior.

## Commit & Pull Request Guidelines
- Commit messages in history use ticket prefixes like `[GT-7154] Short description`.
- Keep messages imperative and scoped to a single change.
- PRs should include a concise description, linked issue/ticket, and screenshots or recordings for UI changes.
- Note test coverage or commands run (for example, `npm run lint` and `npm run test`).

## Configuration Tips
- App config lives in `packages/jfc-global-template/template/next.config.mjs`.
- Localization is generated from `src/locales/**/*.json` via `npm run locales:build`.
