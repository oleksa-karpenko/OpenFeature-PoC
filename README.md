# OpenFeaturePoC

This is a Proof of Concept (PoC) project demonstrating how to integrate **feature flags** into an iOS application using the [OpenFeature](https://openfeature.dev) library.

## 🎯 Purpose

The goal of this project is to test the architecture and integration of **OpenFeature** in a SwiftUI application. OpenFeature provides an abstraction over different feature flag systems, allowing flexibility and portability across providers.

## 🧩 Components

-   **OpenFeature SDK for iOS** — core abstraction layer for feature flag evaluation.
-   **MockFeatureProvider** — a lightweight provider useful for local testing and unit tests.
-   **FlagsmithProvider** — a real-world provider integrated with the [Flagsmith](https://flagsmith.com) platform.

## 🚩 Feature Flags Used

The following flags are registered in the Flagsmith system:

| Flag Key               | Purpose                                                                |
| ---------------------- | ---------------------------------------------------------------------- |
| `new-ui-enabled`       | Controls the appearance of `DetailView` (shows different UI variants). |
| `use-experimental-api` | Reserved for future logic using an experimental backend API.           |
| `can-open-details`     | Toggles visibility of the "Go to Detail View" button in the UI.        |

## ⚙️ Feature Flag Service Behavior

-   At **application launch**, flags are downloaded from the provider (e.g., Flagsmith).
-   Once loaded, flags are stored locally and **evaluated instantly** by key when needed.
-   The app **automatically re-downloads flags** when transitioning from background to foreground (see `TheApp.swift`).
-   The UI is **automatically updated** based on changes in feature flag values.

## 🧪 Unit Tests

Unit tests are planned and will be added in the next development stage. The `MockFeatureProvider` makes it easy to test views and services in isolation from external systems.

## 📦 Structure

-   `FeatureFlagService` — central service for loading, storing, and resolving feature flags.
-   `MockFeatureProvider` — simple provider for test scenarios.
-   `FlagsmithFeatureProvider` — implementation of `FeatureProvider` that fetches flags from Flagsmith.
-   `ContentView` — main view displaying all available flags and navigation.
-   `DetailView` — view conditionally displayed based on `can-open-details` flag.
-   `TheApp.swift` — handles app lifecycle events and triggers flag reloads on resume.

## 🔧 Future Work

-   Add support for traits and identity-based targeting.
-   Integrate automated tests for flag resolution and UI behavior.
-   Add support for additional providers and environments.

---
