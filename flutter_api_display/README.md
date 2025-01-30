# **Flutter Public API Data Display**  

## **Project Overview**  

This Flutter application fetches and displays data from a public REST API (`https://jsonplaceholder.typicode.com/posts`). The app follows the **MVVM (Model-View-ViewModel) + Repository** architecture for clean code structure, scalability, and maintainability.

## **Project Structure**  

```cmd
lib/
│── business_logic/          # Contains ViewModels for state management
│── models/                  # Defines data models
│── presentation/            # UI components (screens & widgets)
│── repositories/            # Implements data fetching logic
│── repositories_interface/  # Abstract repository interfaces
│── main.dart                # Entry point of the application
```

---
