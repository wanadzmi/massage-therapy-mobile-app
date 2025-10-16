# Therapy Massage App - GetX Architecture

This Flutter project follows the GetX pattern for state management and follows a clean, modular architecture.

## 📁 Folder Structure

```
lib/
└── app/
    ├── core/                     # Core application components
    │   ├── theme/               # App theming
    │   │   ├── app_colors.dart  # Color definitions
    │   │   └── app_theme.dart   # Theme configuration
    │   └── values/              # App constants and strings
    │       ├── app_constants.dart
    │       └── app_strings.dart
    ├── data/                    # Data layer
    │   ├── models/              # Data models
    │   │   ├── booking_model.dart
    │   │   ├── service_model.dart
    │   │   └── user_model.dart
    │   ├── providers/           # API providers (HTTP clients)
    │   ├── repositories/        # Data repositories
    │   └── services/            # Business logic services
    ├── global_widgets/          # Reusable widgets across the app
    │   ├── custom_button.dart
    │   └── loading_widget.dart
    ├── modules/                 # Feature modules
    │   ├── auth/                # Authentication module
    │   │   ├── bindings/        # Dependency injection
    │   │   │   └── auth_binding.dart
    │   │   ├── controllers/     # Business logic
    │   │   │   └── auth_controller.dart
    │   │   └── views/           # UI screens
    │   │       └── auth_view.dart
    │   ├── booking/             # Booking management
    │   │   ├── bindings/
    │   │   ├── controllers/
    │   │   └── views/
    │   ├── home/                # Home screen
    │   │   ├── bindings/
    │   │   ├── controllers/
    │   │   └── views/
    │   ├── profile/             # User profile
    │   │   ├── bindings/
    │   │   ├── controllers/
    │   │   └── views/
    │   └── services/            # Services catalog
    │       ├── bindings/
    │       ├── controllers/
    │       └── views/
    ├── routes/                  # Navigation and routing
    │   ├── app_pages.dart       # Page definitions
    │   └── app_routes.dart      # Route constants
    └── utils/                   # Utility functions
        ├── datetime_helper.dart
        └── validators.dart
```

## 🏗️ Architecture Pattern

This project uses the **GetX Pattern** which includes:

### Controllers
- Handle business logic and state management
- Extend `GetxController`
- Use reactive programming with `.obs` variables
- Lifecycle methods: `onInit()`, `onReady()`, `onClose()`

### Views
- UI screens that extend `GetView<ControllerType>`
- Reactive UI updates using `Obx()` widgets
- No direct state management in views

### Bindings
- Dependency injection for controllers
- Extend `Bindings` class
- Define dependencies in the `dependencies()` method

### Models
- Data classes with JSON serialization
- Include `fromJson()` and `toJson()` methods
- Immutable data structures

## 🚀 Key Features

### State Management
- **Reactive Variables**: Use `.obs` for observable variables
- **Obx Widget**: Automatically rebuild widgets when observable changes
- **GetxController**: Lifecycle-aware controllers

### Navigation
- **Named Routes**: Centralized route management
- **Route Arguments**: Pass data between screens
- **Navigation Methods**: 
  - `Get.to()` - Push new screen
  - `Get.off()` - Replace current screen
  - `Get.offAll()` - Clear stack and push

### Dependency Injection
- **Lazy Loading**: Controllers created when needed
- **Automatic Disposal**: Controllers disposed when not needed
- **Service Location**: `Get.find<T>()` to retrieve instances

## 📱 App Modules

### Authentication (`/auth`)
- Login and registration
- User session management
- Token handling

### Home (`/home`)
- Dashboard with quick actions
- Navigation to other modules
- Welcome interface

### Services (`/services`)
- Browse available therapy services
- Service details and pricing
- Quick booking access

### Booking (`/booking`)
- Create new appointments
- Select dates and times
- Booking confirmation

### Profile (`/profile`)
- User profile information
- Booking history
- Settings and logout

## 🛠️ Getting Started

1. **Add GetX Dependency**
   ```yaml
   dependencies:
     get: ^4.6.6
   ```

2. **Configure Main App**
   ```dart
   import 'package:get/get.dart';
   import 'app/routes/app_pages.dart';
   
   class MyApp extends StatelessWidget {
     @override
     Widget build(BuildContext context) {
       return GetMaterialApp(
         title: 'Therapy Massage App',
         initialRoute: AppPages.INITIAL,
         getPages: AppPages.routes,
       );
     }
   }
   ```

3. **Create Controllers**
   ```dart
   class HomeController extends GetxController {
     final count = 0.obs;
     void increment() => count++;
   }
   ```

4. **Build Reactive UI**
   ```dart
   class HomeView extends GetView<HomeController> {
     @override
     Widget build(context) {
       return Obx(() => Text('${controller.count}'));
     }
   }
   ```

## 🔧 Best Practices

- **Single Responsibility**: Each controller handles one feature
- **Reactive Programming**: Use `.obs` for state that affects UI
- **Clean Architecture**: Separate data, domain, and presentation layers
- **Dependency Injection**: Use bindings for controller lifecycle management
- **Navigation**: Use named routes for better organization
- **Error Handling**: Implement try-catch in async operations
- **Loading States**: Show loading indicators during API calls

## 📚 Additional Resources

- [GetX Documentation](https://pub.dev/packages/get)
- [Flutter Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Reactive Programming in Flutter](https://flutter.dev/docs/development/data-and-backend/state-mgmt/intro)

---

**Note**: Remember to add the GetX dependency to your `pubspec.yaml` file and run `flutter pub get` to install the package before running the application.