# Athan Lite — Ad-Free Prayer App (Starter Project)

A simple, **ad-free** Islamic app for Android with:
- Prayer times (calculated on-device, no API/internet needed)
- Azan notifications at each prayer time
- Qibla finder (compass pointing to the Kaaba)
- Hijri / Islamic calendar

Built so you can bolt on more features later (Tasbih counter, Quran, Dua/Athkar, etc.)
without restructuring anything — see "Adding Features Later" at the bottom.

No ads, no in-app purchases, no analytics, no ad SDKs. Everything runs locally
on the phone except the initial map/compass sensor reads, which are also local.

---

## Part 1 — One-time setup (you have nothing installed yet)

You're building a **Flutter** app — one codebase that compiles to a real Android
APK. This is the easiest path for someone without a dev environment because
Android Studio installs everything you need (Android SDK, emulator, build
tools) through one graphical installer.

### Step 1: Install Android Studio
1. Download it from https://developer.android.com/studio
2. Run the installer, keep all default options checked (Android SDK,
   Android Virtual Device, etc.)
3. Open Android Studio once, let it finish the "SDK Component" setup wizard.

### Step 2: Install Flutter
1. Download the Flutter SDK zip: https://docs.flutter.dev/get-started/install
   (pick your OS — Windows/Mac/Linux)
2. Unzip it somewhere permanent, e.g. `C:\src\flutter` or `~/flutter`
3. Add `flutter/bin` to your system PATH:
   - **Windows**: Search "Environment Variables" → Edit `Path` → add the
     folder path ending in `\flutter\bin`
   - **Mac/Linux**: add this line to `~/.zshrc` or `~/.bashrc`:
     `export PATH="$PATH:$HOME/flutter/bin"`
4. Open a **new** terminal window and run:
   ```
   flutter doctor
   ```
   This checks your setup. Fix anything it flags with a red ✗ (it gives you
   the exact command, e.g. accepting Android licenses:
   `flutter doctor --android-licenses`).
5. In Android Studio: **Settings → Plugins** → search "Flutter" → Install
   (this also installs the Dart plugin automatically). Restart Android Studio.

### Step 3: Create the Flutter project shell
Open a terminal, `cd` to wherever you keep projects, then run:
```
flutter create athan_lite
```
This generates the `android/`, `ios/`, etc. platform folders that this
starter project doesn't include (they're boilerplate, no need to hand-write
them).

### Step 4: Drop in this starter code
Copy from this download into the project `flutter create` just made,
**overwriting** the generated `lib/main.dart` and `pubspec.yaml`:
```
athan_lite/lib/            →  <your_project>/lib/
athan_lite/pubspec.yaml    →  <your_project>/pubspec.yaml   (overwrite)
```

### Step 5: Add the required packages
From inside `<your_project>`, run these one at a time. This lets Flutter
pick versions that are actually compatible with your installed SDK (safer
than me guessing version numbers):
```
flutter pub add adhan
flutter pub add geolocator
flutter pub add flutter_compass
flutter pub add flutter_local_notifications
flutter pub add timezone
flutter pub add hijri
flutter pub add intl
```

### Step 6: Add Android permissions
Open `android/app/src/main/AndroidManifest.xml` in your project and add the
lines from `athan_lite/android_manifest_additions.xml` (included in this
download) — permissions go inside `<manifest>`, receivers go inside
`<application>`. Comments in that file show exactly where.

### Step 7: Set minimum Android SDK version
Open `android/app/build.gradle` (or `build.gradle.kts`) and make sure:
```
minSdk = 23
```
(flutter_local_notifications requires at least API 23.)

---

## Part 2 — Run it

1. Plug in your phone via USB with **Developer Options → USB Debugging**
   enabled (Settings → About Phone → tap "Build number" 7 times to unlock
   Developer Options, then enable USB Debugging inside it).
2. In your terminal, from the project folder:
   ```
   flutter devices
   ```
   Confirm your phone shows up.
3. Run:
   ```
   flutter run
   ```
   This installs a debug build straight onto your phone.

---

## Part 3 — Build the real, installable APK

When you're happy with it:
```
flutter build apk --release
```
The APK will be at:
```
build/app/outputs/flutter-apk/app-release.apk
```
Copy that file to your phone (USB, email to yourself, Google Drive, etc.)
and tap it to install. Android will warn about "installing from unknown
sources" the first time — that's expected for any app installed outside
the Play Store; allow it for this install.

---

## Notes on accuracy & permissions

- **Prayer times**: calculated with the `adhan` package using standard
  astronomical formulas — the same approach most prayer-time apps use.
  Default method is Muslim World League; change it in the Settings tab.
- **Qibla**: uses great-circle bearing math + your phone's compass sensor.
  Compass sensors don't work in emulators — test on a real device.
- **Location**: defaults to Toronto until you tap the location icon and
  grant permission (this app never sends your location anywhere; it's
  used only to compute prayer times/Qibla locally).
- **Notifications**: Android 13+ requires you to grant the notification
  permission (the app requests this on first launch). Some phone brands
  (Samsung, Xiaomi, Huawei) aggressively kill background apps — you may
  need to disable battery optimization for this app in phone Settings for
  Azan alarms to fire reliably.

---

## Adding features later

The project is intentionally split into `services/` (logic) and
`screens/` (UI), wired together in `lib/screens/home_shell.dart`.

To add something like a **Tasbih Counter**:
1. Create `lib/screens/tasbih_screen.dart` (a simple `StatefulWidget` with
   a counter — no new package needed).
2. Import it in `home_shell.dart`.
3. Add it to the `_screens` list and add a matching `NavigationDestination`
   to `_navItems`.

To add **Quran text/audio** later, you'd add a package like `quran` or
`quran_flutter` (or bundle your own Quran JSON/audio assets) the same way —
new screen, new service if needed, one line added to the nav list.

Settings are centralized in `lib/models/prayer_settings.dart` — add new
fields there (e.g. `preferredReciter`) as you add features, and pass
`copyWith` updates the same way the existing screens do.
