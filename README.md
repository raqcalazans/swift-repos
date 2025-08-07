<p align="center">
  <img src="https://github.com/user-attachments/assets/2b374a6a-9735-4aab-b39b-5f1a2008675b" width="200" alt="SwiftRepos App Icon">
</p>

![Swift Version](https://img.shields.io/badge/Swift-5.5%2B-orange)
![Platform](https://img.shields.io/badge/Platform-iOS%2013%2B-lightgrey)
![Architecture](https://img.shields.io/badge/Architecture-TCA--inspired%2BCoordinator-blue)
[![SwiftRepos CI](https://github.com/raqcalazans/swift-repos/actions/workflows/ci.yml/badge.svg)](https://github.com/raqcalazans/swift-repos/actions/workflows/ci.yml)

SwiftRepos is a native iOS application developed as a technical challenge. It consumes the GitHub API to display a list of the most popular Swift repositories, allowing users to view their respective pull requests. The project was built with a strong focus on modern software architecture, code quality, testability, and automation.

---

## Features

-   **Popular Repositories**: Displays a paginated list of the most starred Swift repositories on GitHub.
-   **Infinite Scroll**: Automatically fetches and appends the next page of results as the user scrolls.
-   **Pull Request List**: Shows a detailed list of pull requests for a selected repository, including author, title, body, and creation date.
-   **PR Details**: Opens the official pull request page on GitHub within a webview.
-   **Robust Error Handling**: Handles API errors gracefully, including a non-intrusive toast notification for pagination failures.
-   **Empty States**: Provides clear user feedback when a repository has no pull requests.

---

## Architecture

The application is built upon a modern, scalable, and highly testable architecture inspired by **The Composable Architecture (TCA)**, combined with the **Coordinator** pattern for navigation.

-   **TCA-inspired Unidirectional Data Flow**:
    -   **Store**: A generic, centralized state manager for each feature. It receives `Actions`, runs them through a `Reducer`, and executes side `Effects`.
    -   **State**: A simple `struct` that holds the entire state for a given feature, acting as the single source of truth.
    -   **Action**: An `enum` representing all possible events that can occur, from user interactions to API responses.
    -   **Reducer**: A pure function `(inout State, Action, Dependency) -> Effect?` that is responsible for all state mutations. Its purity makes business logic extremely easy to test.
    -   **Effect**: Represents asynchronous side effects (like API calls) that are executed by the `Store` and feed data back into the system by sending new `Actions`.

-   **Coordinator Pattern**:
    -   Navigation logic is completely decoupled from the `ViewControllers`.
    -   The `AppCoordinator` manages the main navigation flow, while feature-specific coordinators (like `RepositoryCoordinator`) handle navigation between related screens.
    -   Coordinators also act as a **Factory**, responsible for creating and injecting all dependencies for a given feature.

-   **Generic `BaseViewController`**:
    -   A generic base class was implemented to handle common `UIViewController` logic (ViewModel injection, `DisposeBag` management), reducing boilerplate code and ensuring consistency.

---

## Technical Choices & Justifications

-   **Swift Concurrency (`async/await`)**: Chosen for the network layer over traditional completion handlers. This provides significantly improved readability, a unified `try/catch` error handling mechanism, and compile-time safety against common concurrency bugs like forgetting to call a completion handler.
-   **RxSwift**: Used as the reactive framework to bind the `State` from the `Store` to the UI. Its `Driver` and `Signal` units are perfect for safely updating the UI from the main thread, while its powerful operators simplify the handling of user input (`Inputs`) and data streams (`Outputs`).
-   **View Code & Design System**: The entire UI was built programmatically to provide maximum control and avoid the overhead of Storyboards. A `DesignSystem.swift` file was created to centralize all UI constants (spacing, colors, typography, layout values), ensuring visual consistency and making future redesigns trivial.
-   **Resilience (Optional Models)**: All data models that map to the API response have optional properties. This makes the app fault-tolerant and resilient, preventing crashes if the API returns incomplete or null data for any field.
-   **Localization**: User-facing strings are managed through a **String Catalog** (`.xcstrings`) and accessed via a type-safe extension, eliminating "magic strings" and preparing the app for future translation.

---

## Libraries Used

| Library | Purpose |
| :--- | :--- |
| **RxSwift/RxCocoa** | Reactive programming framework for binding UI and managing data streams. |
| **Kingfisher** | Efficient asynchronous image downloading and caching. |
| **Fastlane** | Automation tool for running tests from the command line. |

---

## Getting Started

**Prerequisites:**
* macOS
* Xcode 16+ (Swift 5.5+)
* Ruby and Bundler (for Fastlane)

**Instructions:**

1.  Clone the repository:
    ```bash
    git clone https://github.com/raqcalazans/swift-repos.git
    ```
2.  Navigate to the project's root directory:
    ```bash
    cd swift-repos
    ```
3.  Install Ruby dependencies:
    ```bash
    bundle install
    ```
4.  Open `SwiftRepos.xcodeproj` in Xcode. The Swift Package Manager will automatically resolve the project dependencies (RxSwift, Kingfisher).
5.  Build and run the project (`Cmd + R`).

---

## Testing & CI

-   **Unit Tests**: The project includes a suite of unit tests for the `Reducer` functions. Thanks to the TCA-inspired architecture, the core business logic is tested synchronously and without needing to mock complex asynchronous dependencies.
-   **Continuous Integration (CI)**: A CI pipeline is configured using **Fastlane** and **GitHub Actions**. The workflow, defined in `.github/workflows/ci.yml`, automatically runs all unit tests for every pull request targeting the `main` branch, ensuring code quality and stability.

---

## Future Improvements

-   **Integration & UI Tests**: Expand the test suite to include integration tests for the `APIService` against the real GitHub API and UI tests to validate user flows.
-   **Full Localization**: Add translations for other languages (e.g., Portuguese, Spanish) to the `Localizable.xcstrings` catalog.
-   **Enhanced Error Messages**: Implement more user-friendly error views with custom messages for different error types (e.g., "No internet connection" vs. "Server error").
-   **UI Enhancements**: Explore more advanced UI effects, such as the "Liquid Glass" (glassmorphism) style for the cells.
-   **App Icon Variants**: Create Dark Mode and Tinted versions of the App Icon to better integrate with the system's appearance.

---

## Screenshots

| Repository List | Pull Request List |
| :---: | :----: |
|  <img width="200" alt="Screenshot Repository List screen" src="https://github.com/user-attachments/assets/f0bf5bd0-5202-4b94-97d3-7cfa4108c3a2" /> | <img width="200" alt="Screenshot Pull Request List screen" src="https://github.com/user-attachments/assets/5b186fd8-2e4a-4f21-81bf-ba8fe97ee4cd" /> |
