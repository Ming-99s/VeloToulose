# VeloToulouse

A redesigned Flutter mobile application for the VeloToulouse bike-sharing service, developed as part of the Advanced Mobile Development course.

---

## Table of Contents

1. [Introduction](#introduction)
2. [Demo](#demo)
3. [Diagrams](#diagrams)
4. [Getting Started](#getting-started)
5. [Team](#team)

---

## Introduction

This project redesigns the VeloToulouse bike-sharing application with a focus on improved user experience and interface quality. The application is built following the MVVM (Model-View-ViewModel) architectural pattern with clean code principles, ensuring a scalable and maintainable codebase.

Key aspects of the project include:

- User story-driven feature development
- MVVM architecture with Provider for state management
- Clean separation of concerns across data, domain, and presentation layers
- Modern UI design with a consistent design system

**Tech Stack:** Flutter, Dart, flutter_map, Geolocator, Lottie, SharedPreferences

---

## Demo

> Demo video add here.

---

## Diagrams

### UML Class Diagram

> UML diagram add here.

### Sequence Diagram

> Sequence diagram add here.

---

## Folder Structure

```
lib/
├── main_dev.dart              # App entry point
├── main_common.dart           # Common app bootstrap
├── core/
│   ├── constant/              # App-wide constants (colors, text styles)
│   ├── enum/                  # Shared enumerations (BikeStatus, PassType, etc.)
│   └── widgets/               # Reusable UI components (AppButton, Navbar)
├── models/                    # Domain models (Bike, Station, Ride, Pass, User, ...)
├── dtos/                      # Data Transfer Objects with fromJson/toJson
├── repositories/              # Abstract interfaces and mock/local implementations
└── features/
    ├── splash/                # Splash screen with Lottie animation
    ├── onBoarding/            # Onboarding flow
    ├── auth/                  # Authentication
    ├── map/                   # Map view, station markers, bike selection
    ├── ride/                  # Active ride management
    ├── booking/               # Bike booking flow
    ├── profile/               # User profile, passes, balance
    └── notification/          # In-app notifications
```

Each feature follows the MVVM pattern:

```
feature/
├── view/         # UI screens and widgets
├── viewmodels/   # Business logic and state (ChangeNotifier)
└── widgets/      # Feature-scoped reusable widgets
```

---

## Getting Started

### Prerequisites

- Flutter SDK (3.x or later)
- Dart SDK
- Android Studio or Xcode for device emulation

### Installation

```bash
git clone <repository-url>
cd VeloToulose
flutter pub get
flutter run
```

---

## Team

| Role | Name |
|------|------|
| Advisor | Mr. Ronan Ogor |
| Developer | Peng Lyming |
| Developer | Long Chhun Hour |
| Developer | Vy Vicheka |

---

## Acknowledgements

We would like to express our sincere gratitude to **Mr. Ronan Ogor** for his dedicated guidance, constructive feedback, and continuous support throughout this project. His expertise and commitment were invaluable to our progress.

We also thank each team member Peng Lyming, Long Chhun Hour, and Vy Vicheka for their hard work, collaboration, and dedication in bringing this project to completion.
