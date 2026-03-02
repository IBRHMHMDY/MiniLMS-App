# Mini LMS - Mobile Application

A cross-platform mobile application for a Learning Management System, built with **Flutter**. This application is engineered with strict adherence to **Clean Architecture** principles, ensuring high scalability, maintainability, and testability.

## 📱 Tech Stack & Libraries

* **Framework:** Flutter
* **State Management:** `flutter_bloc` / `equatable`
* **Networking:** `dio` (with custom Interceptors for Auth & Error Handling)
* **Routing:** `go_router` (Declarative routing)
* **Dependency Injection:** `get_it` (Service Locator)
* **Local Storage:** `flutter_secure_storage`
* **Functional Programming:** `dartz` (Either type for Failure/Success handling)

## Clean Architecture Structure

The project strictly separates concerns into three main layers for every feature:

```text
lib/
 ┣ core/                # Shared utilities, Network Client, Global Theme, Core Widgets
 ┣ injection/           # Service Locator (Dependency Injection setup)
 ┗ features/            # Feature-based modularization
    ┣ auth/
    ┣ profile/
    ┣ courses/
    ┗ learning/
       ┣ domain/        # Entities, Repositories Interfaces, UseCases
       ┣ data/          # Models, Remote/Local Data Sources, Repositories Impl
       ┗ presentation/  # Blocs, Events, States, Screens, Feature-specific Widgets
```
## Key Features

* **Global Design System:** Centralized ThemeData and Core Widgets ensuring consistent UI/UX.

* **Reactive UI:** Built entirely using the Bloc pattern to separate Business Logic from UI components.

* **Standardized Error Handling:** All API errors are intercepted centrally via Dio and converted into Failure domain objects.

* **Complete User Journey:** Auth (Login, Register, Forgot Password), Browse Courses, Enroll, and View Lessons.

## Running the App Locally

**Clone the repository:**

```bash
git clone <your-repository-url>
cd mini_lms_mobile
Install packages:

flutter pub get
```

Backend Connection Configuration:

Make sure the Laravel backend is running.

By default, the app is configured to connect to 
```bash http://10.0.2.2:8000/api/v1``` 
for the Android Emulator.

If testing on a physical device update the baseUrl in lib/core/network/dio_client.dart to your machine's local IP address (
```bash http://192.168.1.x:8000/api/v1 ```).

Run the App:

```bash
flutter run
```