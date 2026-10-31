# Arone Jerome — Portfolio

Flutter web portfolio for Arone Jerome Malicse. The app targets Flutter 3.41.9 (Dart 3.11).

## Run locally

```bash
flutter pub get
flutter run -d chrome
```

## Build for GitHub Pages

The live site is served from `https://rejomeee.github.io/arone-portfolio/`, so the build needs that base path:

```bash
flutter build web --release --base-href /arone-portfolio/
python3 tool/prepare_web.py
```

Pushes to `master` build and deploy through `.github/workflows/build-deploy.yml`.

## Interface

The portfolio uses an indigo and slate theme, a persistent mobile menu, and
scroll-aware section navigation. Sections can be linked directly, for example
`/arone-portfolio/#projects` and `/arone-portfolio/#contact`.

All three original Rive animations are retained: the cloud background, falling
character, and interactive Flutter bird. They respect the device's reduced-motion
preference. Project covers are editorial illustrations, not app screenshots.

The contact form sends through EmailJS, times out after 20 seconds, and keeps the
current draft available after a failed request. Drafts are held in memory only.

## Validate

```bash
flutter analyze
flutter test
flutter build web --release --base-href /arone-portfolio/
python3 tool/prepare_web.py
```

Tests cover section navigation, narrow layouts, enlarged text, direct-section
startup, and mocked contact submission, timeout, and retry behavior. They do not
send live email.

## Ekko: content editor

Open `/ekko/` under the site's base URL (on GitHub Pages:
`/arone-portfolio/ekko/`). The page contains only a password field. Enter the
password chosen in this chat; matching input opens the editor automatically.
Other input stays on the field without an error or submit button.

The password is a **local convenience gate**, not server authentication. Public
publishing is authorized by your GitHub token, not by this password. No backend
or shared credentials are embedded in the site.

1. Edit profile/contact links, Home copy, About, projects, experience, or footer.
2. Review the actual layout with **Preview**. Contact messages are disabled there.
3. Click **Publish**. On the first publish of the session, enter a fine-grained
   GitHub token restricted to `Rejomeee/arone-portfolio` with repository permission
   **Contents: Read and write**. Create one in GitHub Settings > Developer settings
   > Personal access tokens > Fine-grained tokens.
4. Publishing writes only `content/portfolio.json` to `master`. JSON-only commits
   skip the Flutter build. Refresh the public site to see the change; GitHub
   caching may take a few minutes.

The token is held only in memory, never in local/session storage, exported JSON,
URLs, or the repository. Locking, refreshing, or **Disconnect GitHub** forgets it.
Each publish reads fresh file metadata using a unique request URL, avoiding
cached missing-file responses or old SHAs after an earlier publish. GitHub rejects conflicting writes
instead of the editor automatically retrying an overwrite. Branch rules can
still require a different publishing workflow; errors leave the draft intact.

Drafts autosave in this browser's local storage and are not public. They are not
backed up across devices or after browser storage is cleared. **Export JSON**
and **Import JSON** remain available for backups and restoring drafts. Existing
photos and Rive assets are preserved.

The public site first renders its bundled JSON, then loads the latest from:
`https://raw.githubusercontent.com/Rejomeee/arone-portfolio/master/content/portfolio.json`.
Failed requests or invalid content leave the bundled portfolio available. The
source JSON must be publicly readable. This code needs one initial deployment
before the existing live site supports JSON-only updates and publishing.

Prepare the GitHub Pages editor route after building locally (CI does this):

```bash
flutter build web --release --base-href /arone-portfolio/
python3 tool/prepare_web.py
```

The optional `PORTFOLIO_CONTENT_URL` Dart define can point a local test build at
another JSON URL with browser CORS access. For development, `/#ekko` on a fresh
page load also opens the editor.
