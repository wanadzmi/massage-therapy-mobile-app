# Therapy & Massage App - GetX with API Integration

A Flutter application for therapy and massage services built with GetX state management and comprehensive API integration using Dio.

## 🏗️ Architecture Overview

This project follows a clean architecture pattern with GetX for state management and Dio for HTTP networking:

```
lib/app/
├── core/
│   ├── theme/           # App theming and colors
│   └── values/          # Constants and strings
├── data/
│   ├── models/          # Data models (User, Service, Booking)
│   ├── providers/       # API provider and configuration
│   ├── repositories/    # Data repositories (abstraction layer)
│   └── services/        # API services (HTTP calls)
├── modules/
│   ├── auth/           # Authentication module
│   ├── booking/        # Booking management
│   ├── home/           # Dashboard and home screen
│   ├── profile/        # User profile management
│   └── services/       # Service catalog
├── routes/             # Navigation configuration
├── global_widgets/     # Reusable UI components
└── utils/              # Helper functions and utilities
```

## 🔧 Setup and Installation

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)

### Dependencies
Add these to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  get: ^4.6.6
  dio: ^5.3.2
  shared_preferences: ^2.2.2
  intl: ^0.18.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
```

### Installation Steps

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd therapy_massage_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Update main.dart**
   Replace your existing `main.dart` with `main_getx.dart`:
   ```bash
   mv lib/main_getx.dart lib/main.dart
   ```

4. **Configure API endpoint**
   Update the base URL in `lib/app/data/services/base_services.dart`:
   ```dart
   static String? hostUrl = 'https://your-api-endpoint.com';
   ```

5. **Run the application**
   ```bash
   flutter run
   ```

## 🌐 API Integration

### BaseServices Class
The foundation of all API calls, providing:
- Unified HTTP client configuration
- JWT authentication handling
- Request/response interceptors
- Error handling and logging
- Token management

### Service Layer
Each module has its dedicated service class:

- **AuthService**: User authentication, registration, profile management
- **ServicesService**: Therapy services catalog and search
- **BookingService**: Appointment booking and management

### Repository Layer
Repositories act as an abstraction layer between controllers and services:

- **AuthRepository**: Authentication logic
- **ServicesRepository**: Service management with filtering/sorting
- **BookingRepository**: Booking operations with business logic

### API Endpoints

#### Authentication
```
POST /api/auth/login         # User login
POST /api/auth/register      # User registration
GET  /api/auth/profile       # Get user profile
PUT  /api/auth/profile       # Update user profile
POST /api/auth/logout        # User logout
POST /api/auth/refresh       # Refresh token
```

#### Services
```
GET  /api/services           # Get all services
GET  /api/services/:id       # Get service by ID
GET  /api/services?category= # Get services by category
GET  /api/services/search    # Search services
GET  /api/services/featured  # Get featured services
GET  /api/services/categories # Get categories
```

#### Bookings
```
POST /api/bookings           # Create booking
GET  /api/bookings           # Get user bookings
GET  /api/bookings/:id       # Get booking by ID
GET  /api/bookings/history   # Get booking history
GET  /api/bookings/availability # Check availability
POST /api/bookings/cancel/:id # Cancel booking
POST /api/bookings/reschedule/:id # Reschedule booking
```

## 🎯 GetX Implementation

### Controllers
Each module has a dedicated controller managing:
- State management with reactive variables (`.obs`)
- Business logic and API interactions
- Navigation and user feedback

Example controller structure:
```dart
class HomeController extends GetxController {
  // Observable variables
  final _isLoading = false.obs;
  final _data = <Model>[].obs;

  // Getters
  bool get isLoading => _isLoading.value;
  List<Model> get data => _data;

  // Methods
  Future<void> loadData() async {
    _isLoading.value = true;
    try {
      final response = await repository.getData();
      if (response.isSuccess) {
        _data.value = response.data ?? [];
      }
    } finally {
      _isLoading.value = false;
    }
  }
}
```

### Bindings
Dependency injection for each module:
```dart
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
  }
}
```

### Views
Reactive UI components using `Obx` and `GetView`:
```dart
class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => controller.isLoading
          ? LoadingWidget()
          : ListView.builder(...)),
    );
  }
}
```

## 🔐 Authentication Flow

1. **Login/Register**: User credentials sent to API
2. **Token Storage**: JWT token stored in SharedPreferences
3. **Auto-inject**: Token automatically added to authenticated requests
4. **Refresh**: Automatic token refresh when expired
5. **Logout**: Token cleared from local storage

## 📱 Key Features

### Authentication Module
- User login and registration
- Profile management
- Token-based authentication
- Automatic session handling

### Services Module
- Browse therapy services
- Search and filter services
- Service categories
- Featured services

### Booking Module
- Appointment scheduling
- Availability checking
- Booking management (cancel/reschedule)
- Booking history

### Profile Module
- User profile management
- Booking history
- Settings and preferences

## 🛠️ Error Handling

### API Error Handling
```dart
try {
  final response = await apiCall();
  if (response.isSuccess) {
    // Handle success
  } else {
    // Handle API error
    Get.snackbar('Error', response.error.toString());
  }
} catch (e) {
  // Handle network/parsing errors
  Get.snackbar('Error', 'Something went wrong');
}
```

### Global Error Handling
- Network connectivity issues
- API server errors
- Authentication failures
- Validation errors

## 🧪 Testing

### Unit Tests
Test controllers and repositories:
```bash
flutter test test/unit/
```

### Integration Tests
Test API integration:
```bash
flutter test test/integration/
```

### Widget Tests
Test UI components:
```bash
flutter test test/widget/
```

## 🚀 Deployment

### Environment Configuration
Update API endpoints for different environments:

```dart
// Development
static String? hostUrl = 'https://dev-api.therapymassage.com';

// Staging
static String? hostUrl = 'https://staging-api.therapymassage.com';

// Production
static String? hostUrl = 'https://api.therapymassage.com';
```

### Build Commands
```bash
# Debug build
flutter build apk --debug

# Release build
flutter build apk --release

# iOS build
flutter build ios --release
```

## 📚 Additional Resources

- [GetX Documentation](https://pub.dev/packages/get)
- [Dio Documentation](https://pub.dev/packages/dio)
- [Flutter Documentation](https://docs.flutter.dev/)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.