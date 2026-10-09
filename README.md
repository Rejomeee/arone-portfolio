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
```

Pushes to `master` build and deploy through `.github/workflows/build-deploy.yml`.
