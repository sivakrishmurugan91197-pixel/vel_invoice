# GST Invoice Engine - Flutter Mobile App

This is the mobile application port of the GST Invoice Engine, written in Flutter and Dart. It features:
- Complete invoice profile entry (Company name, PAN, GSTIN, Address, Contacts).
- Dynamic list of invoice items (add/remove rows, compute totals/CGST/SGST).
- Full live PDF preview matching the standard physical print sheet format.
- Automatically handles downloading and printing the generated invoice PDF directly into your phone's storage.

---

## How to Build the APK (Android App File)

Since Flutter and Android build environments are heavy to install locally, you can choose one of the following methods to build your APK:

### Method A: Build Automatically Using GitHub Actions (Easiest, No Software Required)

We have already created a pre-configured automation script for you at `.github/workflows/build-apk.yml`.
1. Upload this project to your **GitHub repository** (public or private).
2. Go to the **Actions** tab on your GitHub repository page.
3. Click on the **Build Android APK** workflow on the left sidebar.
4. Click **Run workflow** -> Select branch (e.g. `main` or `master`) -> click **Run workflow**.
5. Once the build finishes (takes ~3-4 minutes), click on the completed run.
6. Scroll down to the **Artifacts** section at the bottom and download the **gst-invoice-app-apk** zip file containing your installable `app-release.apk`!

---

### Method B: Build Locally on Your Computer

If you want to build the APK directly on this Windows machine:

1. **Install Java JDK 17**:
   - Download and install JDK 17 from [OpenJDK](https://adoptium.net/temurin/releases/?version=17).
   - Add it to your System environment variable `JAVA_HOME`.

2. **Install Flutter SDK**:
   - Download the Flutter Windows SDK from [flutter.dev](https://docs.flutter.dev/get-started/install/windows/mobile).
   - Extract the zip file and add the `bin` directory path (e.g. `C:\flutter\bin`) to your System `PATH` variable.

3. **Install Android Command Line Tools**:
   - Install Android Studio, open the SDK Manager, and install "Android SDK Command-line Tools".
   - Accept the Android licenses by running:
     ```bash
     flutter doctor --android-licenses
     ```

4. **Compile the APK**:
   - Open a terminal in this directory (`d:\New folder\test_ve\invoice_flutter`) and run:
     ```bash
     flutter pub get
     flutter build apk --release
     ```
   - Your compiled APK will be available at:
     `invoice_flutter/build/app/outputs/flutter-apk/app-release.apk`
