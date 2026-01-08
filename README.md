# TaskCSC - Educational Course Platform

A comprehensive Flutter application designed for an educational course platform. This app allows users to browse, purchase, and manage online courses with a modern and responsive user interface.

## 🚀 Overview

TaskCSC is built to provide a seamless learning experience (Educational App). Users can sign up, explore popular courses, manage their learning schedule, and track their progress. The app integrates with Firebase for backend services and uses Provider for state management.

## ✨ Key Features

- **User Authentication**: Secure Login and Sign-Up screens using Firebase Auth.
- **Course Management**:
    - Browse popular and all available courses.
    - detailed view of course content, instructor info, and pricing.
    - "My Courses" section to track purchased/enrolled courses.
- **Interactive UI**:
    - Intro screens for new users.
    - Custom bottom navigation (MainShell) and floating menus.
    - Modern design with the "ClashDisplay" font family.
- **Learning Tools**:
    - Schedule management.
    - Course video player/content viewer.
- **Notifications**: Integrated notification system (FCM).
- **Profile & Settings**: Users can manage their account details and app settings.
- **Payment & Discounts**: Dedicated screens for handling course payments and discounts.

## 🛠️ Technology Stack

- **Framework**: [Flutter](https://flutter.dev/) (Dart)
- **State Management**: [Provider](https://pub.dev/packages/provider)
- **Backend & Cloud Services**:
    - **Firebase Authentication**: User identity management.
    - **Cloud Firestore**: Database for courses and user data.
    - **Firebase Storage**: Storing course assets and user images.
    - **Firebase Messaging**: Push notifications.
- **Networking**: `http` package for API calls.
- **Local Storage**: `shared_preferences` for saving user preferences locally.
- **Others**:
    - `image_picker`: For selecting profile pictures.
    - `flutter_local_notifications`: For local alerts.

## 📂 Project Structure

```
lib/
├── Home/                  # Main UI Screens
│   ├── Widgets/           # Reusable widgets (PopularSection, etc.)
│   ├── pages/             # App pages (HomePage, CourseDetail, Profile, etc.)
│   ├── sections/          # UI Sections (FloatingMenu, etc.)
├── log & sign/            # Authentication Screens
│   ├── Login/             # Login logic and UI
│   ├── SignUp/            # Registration logic and UI
├── model/                 # Data Models (e.g., course_model.dart)
├── provider/              # State Management (Login, Menu, Notification)
├── services/              # API and Backend Services
│   ├── api.dart           # API endpoints and helpers
│   ├── course_service.dart # Fetching course data
│   ├── storage_service.dart # generic storage helpers
├── app_initializer.dart   # App startup logic
├── main.dart              # Entry point and routing configuration
```

## ⚙️ Getting Started

### Prerequisites

- **Flutter SDK**: Version `^3.8.1` (as per `pubspec.yaml`).
- **Dart SDK**: Compatible version.
- **Firebase Project**: You need a `google-services.json` (Android) or `GoogleService-Info.plist` (iOS) configured for your project.

### Installation

1.  **Clone the repository**:
    ```bash
    git clone https://github.com/yourusername/taskcsc.git
    cd taskcsc
    ```

2.  **Install Dependencies**:
    ```bash
    flutter pub get
    ```

3.  **Run the Application**:
    ```bash
    flutter run
    ```

## ⚠️ Important Notes

- **SSL Certificates**: The app currently includes an `HttpOverrides` class in `main.dart` that accepts bad certificates (`badCertificateCallback`). This is intended for development environments (e.g., accessing a local API via self-signed certs) and should be handled securely in production.
- **Assets**: Ensure fonts and images are strictly placed in the `assets/` directory as defined in `pubspec.yaml`.

## 🤝 Contributing

Contributions are welcome! Please fork the repository and submit a pull request for any enhancements or bug fixes.
