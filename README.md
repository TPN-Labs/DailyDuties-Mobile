# 💪🏽 About Daily Duties

## -- To be completed --

### 📁 Project Structure

      + assets/
          Images and other static assets
      + lib/
        + config
            All app setups
        + controller
            Logic layer for processing data from the API
        + l10n
            Translations
        + model
            Persistence layer and object (student, meeting, etc) definitions
        + view
            Main user-story screens
        + widget
            Custom re-utilizable elements

        - main.dart <- The main class

## 📦 Installing dependencies

    flutter pub get

## ▶️ Running

    flutter run

## 🔨 Building

Please following the official documentation of Flutter for the pre-requisites steps required for building the
app for a specific platform.
< [iOS Deployment (Flutter docs)](https://docs.flutter.dev/deployment/ios)
< [Android Deployment (Flutter docs)](https://docs.flutter.dev/deployment/android)


    flutter build ipa

Will build an .ipa file in `./build/ios/ipa/[project_name].ipa`. You will use that file for uploading your app
on App Store.

    flutter build appbundle

Will build an .aab file in `./build/app/outputs/bundle/release/app-release.aab`. You will use that file for uploading
your app on Play Store.
