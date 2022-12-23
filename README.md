## Notes
Throughout the codebase - you'll notice documentation. Some are denoted with "// * Developer Note" - these are notes left for the reviewer(s) to gove more insight into the decision process.

There are some bits of pseudo code by these comments to indicate certain features that could be done in a full-fledge production. 

There is a link to a video of the app walkthrough

### Date
December 22ns, 2022 🎅

### Instructions for how to build & run the app
To run, open a terminal in this project directory and run this command:
```flutter run -d [DEVICE ID]```
If you don't know your device id, running ```Flutter devices``` will show you all available devices

### Time spent
7 hours

### Assumptions made
Some assumptions I made were:

- A caching system would be of use so I added a caching system to the local firebase DB. I touched base with Manuel on this and moved forward with the concept. I added 60 minutes caching. I left a Developer Note indicating a diferent direction I'd take for caching if we only needed a caching system and not the remote capabilities that Firebase allows.

- I assumed we'd want a way for the user to refresh the data so I added a refresh function to allow the user to refresh the rocket data by pulling down

- I assumed packages were fine to use but opted not to use any for the stretch goals (aside from the firebase package of course). I decided to not use any packages for Navigator 2.0 since each team uses their own (also should have some understanding of how it works under the hood)


### Assume your application will go into production...
1. What would be your approach to ensuring the application is ready for production
(testing)?

Step 1: Ensure all unit tests are passing
Step 2: Ensure integration tests are passing
Step 3: Test each feature from the engineering / QA team (if aplicable)
Step 3A: Ensure all errors are caught and being handled properly
Step 3B: Test on multiple emulators, physical devices, and operating systems
Step 4: Create and release internal builds (Test flight for iOS, Testing release on the Playstore) and have internal stakeholders test the app
Step 5: Monitor error logging system (Sentry for example)
Step 6: Have the teams download and test the live production app during the soft launch and go over each feature
Step 7: If everything is passing, it's safe to let our users know of the new live version (assuming via email or our marketing channels)

This allows for multiple scenarios, user patterns, and edge cases to be covered

2. How would you ensure a smooth user experience as 1000s of users start using your
app simultaneously?

If this is an app that requires a lot of dynamic data from our servers - implement serverside caching.
If our server hardware isn't strong enough to handle multiple users at one, implement a load balancing function on the servers.
If both of those still aren't enough, add API queueing and throttling to manage the incoming loads on our servers

On the app side - conduct extensive testing especially during initial / major launches

3. What key steps would you take to ensure application security?

- Obfuscate the code so it's dificult to reverse engineer
- Implement jail break detection.
    - A note on Jailbreak detection is it's not always 100% since Jailbreaking a device could implement some code to get around this detection but is still good to have
- Encrypt and obfuscate API keys and credentials
- Restrict permissions to the minimum required to work
- Ensure connections to servers are secured and encrypted
- Any sensitive data and API keys should be included in the secret settings of the app
- Secure all keystore credientials 
- Keep the flutter SDK, dart, and dependencies up-to-date


### Shortcuts/Compromises made
I did not complete the deeplinking stretch goal. I've done deeplinking in 3 diferent ways in the past (from local notifications, from a link on a web page, from a notification sent from Firebase/Saleforce) but opted not to go forward with the deeplinking stretch goal due to time constraints. I do have an example I can show from my current role that I would like to cover.

I was planning on creating a 3D model of a spinning rocket and turning it into a GIF to include in the app (I do 3D modelling and often include them in the app, one example is for an icecream business I'm helping where I'm building their website and have 3D icecream scoops for users to select to build their icecream cones)

### Why did you choose the specific technology/patterns/libraries?
I went forward with using BLoC since that what was in the requirements. My main architecture that I use is MVVM + Provider and I have my past projects from other companies I've worked at where we used this architecture style.

I used the Flutter BLoC package to implement the bloc architecture and bloc_test to test the blocs

### Stretch goals attempted
I implemented the following stretch goals:
- Firebase local DB
- Navigating using Navigator 2.0

I felt it went well. Implementing Navigator 2.0 with BLoC was a challenge since there wasn't much disucssion around it and the other ways I had seen it implemented involved mixing logic in the visual part of the app. I opted to have the bloc control the pages collection in the navigator so when the state is updated to a certain state, it'll ensure that the correct screen is shown. I'm sure there's a better way of doing it but the main thing I wanted to happen was ensure the logic contained in the bloc was able to control the navigation of the detail screen.

### Other information about your submission that you feel it's important that we
I'll include a link to a video to show it running in case something causes the app not to run on the testing device (diferent SDK versions, hardware restriction). It should run but just as a safety fallback.

Link to video: https://youtu.be/17fw0qi8mcc

This is a screenshot of the error screen I've included in the app in the event there's an unhandled error. This has proven to be extremely useful when debugging in staging and pre-prod release builds

![Alt text](/error_screen_ex.png "Error screen")

### Your feedback on this technical challenge
Challenge was great, covered the main bases that most apps will encounter (architecture, seperation of concerns, API calls and response, error handling, etc). 

The only addition I would included is having another screen included in a tab view that would allow for user input. I'd also include a stretch goal of grabbing other types of info from the API (grabbing the satellites, missions, ships) and let the user filter through each time

Test was great! 
