### Summary: Include screen shots or a video of your app highlighting its features
Feature Overview - [YouTube Video](https://youtu.be/nLRhKFkjFeU)

I built a SwiftUI recipe browser that displays recipes grouped by cuisine type, with image caching and external links to source recipes and YouTube videos when available. The app features comprehensive error handling, VoiceOver support, and pull to refresh functionality.

### Focus Areas: What specific areas of the project did you prioritize? Why did you choose to focus on these areas?
* Implemented actor-based image caching for thread safety
* Built responsive UI with SwiftUI and MVVM architecture
* Added comprehensive VoiceOver support with custom labels and hints

### Time Spent: Approximately how long did you spend working on this project? How did you allocate your time?
6 hours of development time on January 30th, plus additional time for video walkthrough. Time was allocated across:
* Requirements analysis and architecture planning
* Core implementation and UI development 
* Testing and documentation

### Trade-offs and Decisions: Did you make any significant trade-offs in your approach?
* Recipe Model: I used wrapper variables for optional URLs instead of a custom decoder. In production, I'd write a custom decoding function to map variables directly to their final types.
* API Configuration: I put the API URLs in an enum for simple testing. In a real app, I'd use environment-specific configuration files for each target.
* Image caching: Basic memory/disk caching implemented without:
  - Cache size limits
  - Cleanup policies
  - File expiration
  - Memory pressure handling
* iOS Support: I chose to target iOS 16 to align with Fetch's requirements

### Weakest Part of the Project: What do you think is the weakest part of your project?
Overall I'm happy with the implementation, although I'd say the image caching system is the area that would be the weakest point of the project. As noted in my trade-offs, it's lacking some production-required features like size management, cleanup, and expiration policies.

### Additional Information: Is there anything else we should know? Feel free to share any insights or constraints you encountered.
Technical Highlights:
* Thread-safe image caching using actors
* Comprehensive error handling with user-friendly messages
* Full test coverage across API, caching, and view model layers
* Recipes grouped and sorted by cuisine type
* Pull-to-refresh support

Project setup:
* Requires iOS 16.0+
* Clone and open in Xcode
* Build and run - no other setup needed
* Use Cmd+U to run the tests.
