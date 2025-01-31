# **Flutter Public API Data Display**  

## **Project Overview**  

This Flutter application fetches and displays data from a public REST API (`https://jsonplaceholder.typicode.com/posts`). The app follows the **MVVM (Model-View-ViewModel) + Repository** architecture for clean code structure, scalability, and maintainability.  

---

## **Project Structure**  

### **Folders**  

- **`business_logic/`** → Contains Providers (ViewModels) responsible for managing state and interacting with repositories.  
- **`core/`** → Contains fundamental application infrastructure including:
  - Custom provider implementations for dependency injection
  - Base exception handling system
  - Result type definitions for error handling
- **`models/`** → Defines data models used throughout the application.  
- **`presentation/`** → Contains UI components, including screens and widgets.  
- **`remote_config/`** → Manages configurations for API services and remote settings.  
- **`repositories/`** → Implements repository logic to fetch data from external APIs or local sources.  
- **`repositories_interface/`** → Defines abstract repository interfaces, ensuring dependency inversion and testability.  
- **`utilities/`** → Contains global utilities such as logging and helper functions.  

---

### **Root Files**  

- **`logic_providers.dart`** → Centralizes ViewModel (Provider) creation and configuration using `MultiProvider`. Injects repository dependencies into ViewModels and makes them accessible throughout the widget tree.

- **`repository_providers.dart`** → Centralizes repository creation and configuration using `MultiRepositoryProvider`. Injects dependencies like `RemoteConfig` into repositories and makes them accessible throughout the widget tree.

- **`main.dart`** → Entry point that:
  - Initializes Flutter bindings
  - Sets up remote configuration
  - Configures logging
  - Bootstraps the widget tree with repository and logic providers

---

### **🚀 Next Steps (Features Not Implemented Yet)**  

To further enhance the app, the following features should be implemented:  

✅ **Offline Caching** → Store fetched posts locally to reduce API calls and support offline access.  
✅ **Localization Support** → Add support for multiple languages using Flutter’s `intl` package.  
✅ **Unit & Widget Testing** → Write tests for `PostProvider`, API calls, and UI components.  
✅ **Post Details Caching** → Cache previously viewed posts to avoid re-fetching the same data.  
✅ **Accessibility Improvements** → Ensure proper screen reader support and text scaling options.  
✅ **Smooth Animations & Transitions** → Add animations and smooth page transitions for better UX.
✅ **App Icon** → Design and set a custom app icon to enhance the app's visual identity and make it easily recognizable on users' devices.
