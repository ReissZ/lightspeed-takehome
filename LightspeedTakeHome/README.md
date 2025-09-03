#  Lightspeed Take Home

A simple iOS app that fetches random images from Picsum (https://picsum.photos), persists them locally with Core Data, and displays them in a reorderable/deletable list.

Built with SwiftUI, async/await, Core Data, and MVVM.

------------------------------------------------------------
✨ Features
------------------------------------------------------------
- Fetch random photo from the API (https://picsum.photos/v2/list).
- Persist photos locally in Core Data.
- Display photos in a SwiftUI List (with image + author).
- Delete and reorder items.
- Background Core Data writes with merge policies for smoothness.
- Async/await networking with retry/backoff.
- Light error handling via a shared AlertPresenter.
- Simple in-memory tests for API decoding and persistence.

------------------------------------------------------------
🛠 Tech Stack
------------------------------------------------------------
- Swift 6.1 / Xcode 16.4
- SwiftUI
- Async/Await (Swift Concurrency)
- Core Data (with background contexts + merge policies)
- MVVM architecture
- Unit Tests (XCTest + URLProtocol stubs)

------------------------------------------------------------
🚀 Getting Started
------------------------------------------------------------
1. Clone the repo:
   git clone https://github.com/reissz/lightspeed-takehome.git
   cd lightspeed-takehome

2. Open in Xcode:
   open LightspeedTakeHome.xcodeproj

3. Run:
   - Select an iOS 17+ simulator
   - Build & run (⌘R)

------------------------------------------------------------
🧪 Running Tests
------------------------------------------------------------
From Xcode:
- Run all tests with ⌘U.
- Tests cover:
  - API decoding with a stubbed response
  - In-memory Core Data persistence (insert + fetch)

------------------------------------------------------------
👤 Author
------------------------------------------------------------
Reiss Zurbyk – Senior iOS & Mobile Engineer
LinkedIn: https://www.linkedin.com/in/reiss-zurbyk
GitHub: https://github.com/reissz

------------------------------------------------------------
📄 License
------------------------------------------------------------
This project is provided for Lightspeed take-home evaluation purposes.

