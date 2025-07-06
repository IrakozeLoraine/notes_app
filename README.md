# Notes App

A Flutter mobile application for taking notes with Firebase authentication and Firestore database integration. This app uses the BLoC state management, and complete CRUD operations.

## Architecture Overview

This application follows **Clean Architecture** principles with clear separation of concerns:

```
lib/
├── main.dart                          # App entry point
├── injection_container.dart           # Dependency injection setup
├── core/                             # Core utilities
│   └── utils/snackbar_utils.dart
├── data/                             # Data layer
│   ├── datasources/
│   │   └── firebase_datasource.dart   # Firebase API calls
│   ├── models/
│   │   └── note_model.dart            # Data models
│   └── repositories/
│       └── note_repository_impl.dart  # Repository implementation
├── domain/                           # Business logic layer
│   ├── entities/
│   │   └── note.dart                  # Core entities
│   ├── repositories/
│   │   └── note_repository.dart       # Repository interface
│   └── usecases/                     # Business use cases
│       ├── add_note.dart
│       ├── delete_note.dart
│       ├── get_notes.dart
│       └── update_note.dart
└── presentation/                     # UI layer
    ├── bloc/                         # BLoC state management
    │   ├── auth/
    │   │   ├── auth_bloc.dart
    │   │   ├── auth_event.dart
    │   │   └── auth_state.dart
    │   └── notes/
    │       ├── notes_bloc.dart
    │       ├── notes_event.dart
    │       └── notes_state.dart
    ├── screens/                        # Screen widgets
    │   ├── login_screen.dart
    │   └── notes_screen.dart
    └── widgets/                      # Reusable widgets
        ├── note_card.dart
        ├── note_dialog.dart
        └── loading_widget.dart
```

### Architecture Diagram

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Presentation  │    │     Domain      │    │      Data       │
│                 │    │                 │    │                 │
│  ┌───────────┐  │    │  ┌───────────┐  │    │  ┌───────────┐  │
│  │   BLoC    │  │◄──►│  │ Use Cases │  │◄──►│  │Repository │  │
│  └───────────┘  │    │  └───────────┘  │    │  │Impl       │  │
│  ┌───────────┐  │    │  ┌───────────┐  │    │  └───────────┘  │
│  │   Screens │  │    │  │ Entities  │  │    │  ┌───────────┐  │
│  └───────────┘  │    │  └───────────┘  │    │  │DataSource │  │
│  ┌───────────┐  │    │  ┌───────────┐  │    │  │(Firebase) │  │
│  │  Widgets  │  │    │  │Repository │  │    │  └───────────┘  │
│  └───────────┘  │    │  │Interface  │  │    │  ┌───────────┐  │
│                 │    │  └───────────┘  │    │  │  Models   │  │
│                 │    │                 │    │  └───────────┘  │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## Features

### Authentication
- Email/Password sign-up and login
- Input validation with specific error messages
- Firebase Authentication integration
- Secure logout functionality

### Notes Management (CRUD)
- **Create**: Add new notes with validation
- **Read**: Display all user notes in real-time
- **Update**: Edit existing notes
- **Delete**: Remove notes with confirmation dialog

### User Experience
- Empty state with helpful hint message
- Loading indicators during data fetch
- Success/Error feedback via colored SnackBars
- Responsive design supporting rotation (portrait/landscape)

### Technical Features
- **BLoC State Management**
- **Clean Architecture** (data, domain, presentation)
- **Dependency Injection** using GetIt

## Setup Instructions

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Android Studio / VS Code
- Firebase account

### 1. Clone and Setup Project
```bash
git clone https://github.com/IrakozeLoraine/notes_app.git
cd notes_app
flutter pub get
```

### 2. Firebase Configuration

#### Step 2.1: Create Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Create a project"
3. Follow the setup wizard

#### Step 2.2: Setup Authentication
1. In Firebase Console, go to **Authentication**
2. Click **Get Started**
3. Go to **Sign-in method** tab
4. Enable **Email/Password** provider
5. Save changes

#### Step 2.3: Setup Firestore Database
1. In Firebase Console, go to **Firestore Database**
2. Click **Create database**
3. Choose **Start in production mode**
5. Click **Done**

#### Step 2.4: Configure Firestore Security Rules
Replace the default rules with:
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only access their own notes
    match /users/{userId}/notes/{noteId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

#### Step 2.5: Add Android Configuration
1. In Firebase Console, click **Add app** and select Android
2. Enter package name: `com.example.notes`
3. Download `google-services.json`
4. Place the file in `android/app/` directory
5. Follow the configuration steps in Firebase Console

### Step 2.6: Setup to Firebase in Flutter
1. Run flutterfire configure to initialize Firebase:
```bash
flutterfire configure
```
2. Follow the prompts to select your Firebase project and platforms

### 3. Run the App
```bash
flutter run
```
### 4. Analysis

To run tests, use:
```bash
flutter analyze
````

### Why BLoC?
- **Predictable**: Clear separation between events and states
- **Reusable**: BLoCs can be shared across different UI components
- **Maintainable**: Changes in UI don't affect business logic

## Firebase Integration

### Data Structure in Firestore
```
users (collection)
└── {userId} (document)
    └── notes (subcollection)
        └── {noteId} (document)
            ├── text: String
            ├── createdAt: Timestamp
            └── updatedAt: Timestamp
```
## Contributing

1. Fork the repository
2. Create a feature branch
3. Follow the existing architecture patterns
4. Submit a pull request

## 📄 License

This project is created for educational purposes as part of a Flutter development assignment.
