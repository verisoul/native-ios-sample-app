# native-ios-sample-app

## Overview

This repo provides a working example of integrating Verisoul's webview into an IOS
native app

The app opens the hidden webview and loads the Verisoul webview. The app then listens for a
secure `session_id` from the webview and makes an API call to the Verisoul API to retrieve the account prediction. _The
API call is included as an example but in production this should be done on your backend._

To run the app a Verisoul API Key is required. Schedule a call [here](https://meetings.hubspot.com/henry-legard) to get started.

## Quickstart

1. Download and install the latest [Xcode](https://apps.apple.com/us/app/xcode/id497799835?mt=12)

2. Clone this repo

```console
git clone https://github.com/verisoul/native-ios-sample-app.git
```

3. Open the project in Xcode and update the following variables

- Update `projectId` with your project id in the `ViewController.swift` file
- Update `apiKey` with your api key in the `ZeroFakeDemo.swift` file

4. Save the changes and select the simulator or plug in your IOS device and click Run
