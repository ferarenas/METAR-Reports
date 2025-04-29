# Meteorological Routine Aerodrome Report

This project fetches METAR (aviation weather) reports and displays them in a simple, clean UI.

## Architecture and Design Choices

- **MVVM Architecture**
I decided to use MVVM because I believe it creates a clear separation of concerns, making the codebase easier to scale, maintain, and test over time. It also helps keep the UI code simple and declarative, which fits perfectly with SwiftUI.

- **Dependency Injection**
I used dependency injection to make it easier to add unit tests in the future. By injecting dependencies like the API service into the view models and actors, it becomes much simpler to mock those services during testing without needing to heavily modify production code.

- **Decodable Object Mapping**
I created a Decodable object that directly matches the API response and then mapped it to a MetarReport model that is more friendly for the app to use. This allows the app to stay flexible if the API changes in the future and keeps the app’s logic focused on what it really needs rather than the raw server data.

- **TaskGroup Inside the ScreenModel**
I chose to put the TaskGroup inside the ScreenModel instead of the actor because fetching multiple reports at once is more about coordinating UI-related tasks. This way, the actor stays focused on being a simple, safe cache and data store, without taking on extra responsibility for UI-driven behavior.

- **UI Design Choices**
  - Added a "Refresh from Cache" button to quickly reload saved reports without hitting the network.

  - Added Pull-to-Refresh support to fetch fresh reports from the API easily.

  - Used a ProgressView while loading to improve the user experience and give feedback when data is being fetched.

  - Made sure the UI uses proper padding and spacing for better readability.

  - Displayed error messages when data fails to load — although this can still be improved (see TODOs below).

## Tools Used

- **macOS** 15.4.1

- **Xcode** 16.3

- **iPhone** 16 Pro Max

## How to Run

- Clone the repository.

- Open the .xcodeproj file in Xcode.

- Cmd + R

No extra setup or configuration needed.

## Future Improvements (TODOs)

- **Add a Constants file for:**
  - Strings (to make localization easier in the future).

  - "Magic numbers" used for UI layout, to keep the spacing and sizing consistent across the app.

- **Add Unit Tests:**
Thanks to using dependency injection, it would be easy to swap the real services with mocks and test the view models, actors, and other logic without relying on real network calls.

- **Handle errors more gracefully:**
Right now, the app shows simple error messages. In the future, I’d like to design a better error-handling experience, maybe showing partial data if available, or retry options.

- **Minor UI improvements and polishing.**


Made with ❤️ by **Fernando Arenas**
