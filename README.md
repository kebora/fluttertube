# fluttertube

This application uses the YouTube API to display and play the contents of 3 flutter-related channels.
I have rewritten the code with sound null safety.

## Guides
Much of my reference is from the [Marcus Ng's repo](https://github.com/MarcusNg/flutter_youtube_api).

## Installation
* Visit [Google Cloud Console](https://console.cloud.google.com/), add and enable the YouTube API.
* Create a file in the Utilities folder named keys.dart with the api key initialization as below:

```
const String apiKey = 'your youtube api key from the google console';
```

* Get the packages using pub get and the run the project.
* All the channel ids are stored in utilities/channel_ids.dart.
* To change the channels displayed, watch this video on how to get the id of any channel from youtube. [Video here]('https://www.youtube.com/watch?v=D12v4rTtiYM&t=50s&ab_channel=WebbyFan.com')

Feel free to add new features and make PRs so that we can improve FlutterTube, as we learn more together.
