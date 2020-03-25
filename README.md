# Sloboda

A city building turn-based game written in Flutter and Dart.

# Supported platforms:

- ✅ Android
- ✅ iOS
- ✅ Windows
- ✅ Linux
- ✅ Web

# Try online
[Sloboda Online](https://locadeserta.com/sloboda)

## How to run
Open the project in Android Studio and run against supported platforms.

## Prerequisites
The project is always run on flutter master branch:

```sh
flutter channel master
flutter upgrade

flutter config --enable-web
flutter config --enable-windows
flutter config --enable-linux
```

## How to build native binaries:

Android:
```sh
flutter build apk
```

macOS:
```sh
flutter build macos 
```

Windows:
```
flutter build windows
```

iOS:
```sh
flutter build ios
```

##
macOS binaries are at:

 ```sh
 cd ./build/macos/Build/Products/Release/
```

Web:

```sh
./build/web/
```

# Voxel Art
Use [Goxel](https://goxel.xyz/) application for creating the voxel art.