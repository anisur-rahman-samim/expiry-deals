# Flutter & Simulators Setup — What’s Installed

## Installed on this computer

### Flutter SDK
- **Installed via:** Homebrew (`brew install --cask flutter`)
- **Path:** `/opt/homebrew/share/flutter`
- **Version:** Flutter 3.41.4 (stable), Dart 3.11.1
- **Command:** `flutter` is in your PATH

### iOS Simulators
- **Xcode:** Already installed at `/Applications/Xcode.app` (26.1.1)
- **CocoaPods:** Installed via Homebrew for iOS/macOS Flutter plugins
- **Simulators:** iPhone 17 Pro, iPhone 17 Pro Max, iPhone Air, iPad Pro, etc. (iOS 26.1)
- **Physical device:** "Ricky" (wireless) is also detected

### Android Studio
- **Installed via:** Homebrew (`brew install --cask android-studio`)
- **Path:** `/Applications/Android Studio.app`
- **Command:** `studio` (opens Android Studio)

### Android SDK & emulator (one-time setup)
The Android **SDK is not installed yet**. It is installed the first time you run Android Studio and complete the setup wizard.

**Do this once:**

1. **Open Android Studio**
   - From Spotlight: press `Cmd+Space`, type **Android Studio**, press Enter  
   - Or run in terminal: `open -a "Android Studio"`

2. **Complete the setup wizard**
   - If it says “Android SDK not found”, choose **Next** and accept the default SDK location (e.g. `~/Library/Android/sdk`).
   - Install the suggested SDK components (Android SDK, SDK Platform, etc.).
   - Finish the wizard.

3. **Create an Android Virtual Device (AVD)**
   - In Android Studio: **More Actions** → **Virtual Device Manager** (or **Tools** → **Device Manager**).
   - Click **Create Device** → pick a phone (e.g. Pixel 8) → **Next**.
   - Download a system image (e.g. “Tiramisu” API 34) if asked → **Next** → **Finish**.

4. **Tell Flutter where the SDK is** (if needed)
   - After the wizard, Flutter often finds the SDK automatically. If not:
   ```bash
   flutter config --android-sdk ~/Library/Android/sdk
   ```

5. **Check**
   ```bash
   flutter doctor -v
   ```
   You should see ✓ for Android toolchain and a list of devices that includes your new emulator.

---

## How to run the Expiry Deals app

```bash
cd /Users/ricky/Downloads/expiry-deals-main
```

**iOS Simulator**
```bash
open -a Simulator
flutter run -d ios
# Or pick a device: flutter run -d "iPhone 17 Pro"
```

**Android Emulator** (after SDK + AVD setup)
```bash
# Start emulator from Android Studio (Device Manager → Play) or:
flutter emulators
flutter emulators --launch <emulator_id>
flutter run -d android
```

**Chrome (web)**
```bash
flutter run -d chrome
```

**Web server (localhost)**
```bash
flutter run -d web-server --web-port=8080
# Then open http://localhost:8080
```

**Physical iPhone (“Ricky”)**
```bash
flutter run -d 00008140-0018794C01FB001C
# or
flutter run -d "Ricky (wireless)"
```

---

## Quick check

```bash
flutter doctor -v
```

You want:
- ✓ Flutter
- ✓ Xcode (and CocoaPods)
- ✓ Chrome
- ✓ Android toolchain (after Android Studio first run)
- Connected devices listed at the bottom
