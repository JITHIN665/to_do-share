
# ToDo App - Share & Collaborate

A Flutter-based **ToDo application** that allows users to create, share, and collaborate on tasks. Built using **MVVM architecture**, **Provider** for state management, and **Firebase** for authentication and data storage.

---

## Features

- **User Authentication** via Firebase
- **Add, Edit, Delete, and Mark Tasks as Complete**
- **Real-time Task Sync** between owner and shared users
- **Share tasks by Email** (other media supported too)
- **Responsive UI** - Works across all screen sizes
- **CI/CD Pipeline with GitHub Actions**

---

## Project Structure (MVVM)

```
lib/
🔹 models/           # Task & User models
🔹 views/            # UI screens
🔹 view_models/      # Business logic & state management (Provider)
🔹 services/         # Firebase Auth & Firestore services
🔹 widgets/          # Reusable UI components
🔺 main.dart         # Entry point
```

---

## Test Accounts

You can use the following credentials for testing:

| Email             | Password     |
|------------------|--------------|
| test1@123.com     | Admin123,.   |
| john@123.com      | Admin123,.   |

---

## Task Sharing Logic

- Tasks are **shared by email** (the receiver's email).
- When a user logs in, they receive **all tasks shared** with their email.

---

## Tech Stack

- **Flutter SDK**
- **Firebase Authentication**
- **Cloud Firestore**
- **Firebase Storage**
- **Provider** for state management
- **GitHub Actions** for CI/CD

---

## CI/CD with GitHub Actions

This project includes a GitHub Actions pipeline that:

- Installs Flutter
- Installs dependencies
- Runs analyzer and tests
- Builds APK
- Uploads release artifacts

Workflow file: `.github/workflows/flutter-ci-cd.yml`

---

---

## Getting Started

1. **Clone the repo**
   ```bash
   git clone https://github.com/JITHIN665/to_do-share.git
   cd todo-share-app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

> Note: Ensure you have configured Firebase for Android/iOS/web before running.

---

## Testing CI/CD

Push a commit to the `main` branch and GitHub Actions will automatically:

- Build your Flutter project
- Run tests
- Upload the APK for download under the **Actions > Artifacts** section

---