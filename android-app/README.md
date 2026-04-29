# Sorbr Android App

This folder contains a native Android wrapper (WebView-based) for Sorbr.

## Build an APK

1. Open `android-app/` in Android Studio.
2. Let Gradle sync.
3. Build debug APK:

   ```bash
   ./gradlew assembleDebug
   ```

The APK will be generated at:

`app/build/outputs/apk/debug/app-debug.apk`

## Notes

- This Android app loads the existing PWA at `https://sorbr.com`.
- No existing PWA files in the repository are modified by this Android wrapper.
