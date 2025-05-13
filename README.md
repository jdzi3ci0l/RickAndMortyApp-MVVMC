# RickAndMortyApp

A small SwiftUI project built as a solution to a recruitment task.

![App Demo](img/rickAndMortyAppPreview.mp4)

The app fetches data from the [Rick and Morty API](https://rickandmortyapi.com/) and acts as a character browser.

It consists of three screens:
- CharactersListView
- CharacterDetailsView
- EpisodeDetailsView

Some of the main technical requirements included:
- Creating user interface with SwiftUI - ✅
- Async/Await for networking layer - ✅
- Minimum Deployment Target - iOS 15.0 - ✅

With "Nice to have" including:
- TCA (The Composable Architecture) - ❌*
<sub>*Picked MVVM-C instead because I'm a bit more fluent in it.</sub>
- Usage of native components - ✅
- Error handling - ✅
- Add character to favourites feature (with persistence) - ✅
- Depedency Injection - ✅
- General aesthetics, components design - 🤷‍♂️ I'll let you be the judge!

## App flow

1. **CharactersListView** initially shows a static instruction message and a button to load characters from the API - once they are loaded, a scrollable list is displayed. Additionally, a reset button should be always available for the user to go back to the initial state (showing instructions).
2. **CharacterDetailsView** opens after user selects a character from the list, showing character details. Below the character info, there's a list of episodes the character appears in, shown as: `Episode <episodeNumber>`.
3. **CharacterDetailsView** is triggered when tapping an episode from the character details screen. It displays episode data like its name, air date and total number of characters appearing in that episode.