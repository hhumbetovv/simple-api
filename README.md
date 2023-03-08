# Simple REST Api 

## Required
### [Dart Sdk](https://dart.dev/get-dart)

### [Firebase](https://firebase.google.com/)

## How to use
#### 1. Create a [Firebase Project](https://console.firebase.google.com/)
#### 2. Add [Web app](https://firebase.google.com/learn/pathways/firebase-web) to Project
#### 3. Create [Realtime database](https://firebase.google.com/docs/database) in Firebase Project and set read, write rules to true
#### 4. Add the required Firebase dependencies to bin/configurations.dart file (Realtime database url and Web app's Firebase config)
#### 5. Run this code in the project's root directory

```
dart run ./bin/server.dart
```
Output:
```
Server listening on port 8080
```

### Now you can send requests to given localhost port using postman or insomnia
