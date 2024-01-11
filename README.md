# Dessert Cookbook

## Build Instructions

**Requirements:**
- **Xcode 15** or greater
- An installed simulator running **iOS 17** or greater

**Steps:**
1. Clone this repository or download it as a `.zip` file.
2. Navigate into the `DessertCookbook` folder.
3. Open the `DessertCookbook.xcodeproj` file in Xcode.
4. Once Xcode finishes indexing the project files, click the Run button or press `⌘ + b`.

The application will appear in your simulator under the name _Desserts_.

## Design Approach

For this application, I opted to use the MVVM design pattern to separate my data, presentation, and logic layers. I utilize `NetworkService.swift` as my networking layer and it is responsible for exposing my view models to data model objects. These data models are purposefully agnostic about valid data and formatting details. I leave this job up to the view models, which parse the information from data models into new, clean and "knowledgeable" models. I treat my views in a similar fashion, they are fairly "ignorant" and only know of what the view model wants them to show.

For enhanced performance and reduced network calls, I utilize an image caching system with `ImageCache.swift` and `CachedAsyncImage.swift`. When an image is first obtained from TheMealDB, it is cached away into memory. This allows images to be quickly re-drawn during list cell reuse and displayed in a dessert detail view without any additional network requests.

To provide a better user experience, I chose to fire the request to obtain the in-depth details for a dessert when the user selects a cell in the desserts list - occurring even _before_ the detail view is added to memory or the view hierarchy. This allows me to catch network errors that may occur on the user's end _and_ prevent showing the detail view for desserts that lack adequate information, such as missing instructions or ingredients.

## Future Enhancements

Given additional time, there were a few infrastructure and user features that I would have liked to implement:
1. XCTest cases
2. A more robust caching system that could retain its data between app launches and store entire desserts, not just their images.
   - This could be implemented using UserDefaults and the eTag provided by TheMealDB
3. Bookmarking of desserts for later viewing and persistence between app launches

https://github.com/krtakehomes/DessertCookbook/assets/156035895/3bde60de-3fa6-4c13-bcfb-0acea10bc2b3
