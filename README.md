# unofficial_gencon_mobile

This is the flutter version of the Unofficial Gen Con Mobile app. It is currently in an UNIFINISHED state, and will not be used in production unless it can satisfactorily replace the older Xamarin version.

**WE NEED HELP!** Please see "Code Contributions" and "Other Contributions" below!

## How to build
You may install the Flutter toolset ( https://flutter.dev ) and open the folder like any other project.

## Contributing
All accepted contributions will be merged into the main branch. As this is not currently the production version of the app, we will have discussions on when the app is ready for a production release.

Assuming a satisfactory Flutter version of the app can be completed, the current rollout plan is to migrate the existing Xamarin version of the app to a new "Unofficial Gen Con Legacy" app on each app store. Then, the Flutter version will be issued as an update (along with a major version increase) to the existing "Unofficial Gen Con" app.

There are two ways to contribute:
1. If you can code - Submit a pull request! I'll work with you to get it integrated.
2. If you can submit maps or other guide data (see "Other Contributions" below).

### Code Contributions
The Flutter version of the app is currently in an extremely unusable state. I have included some initial starts on database creation/updates, event downloads, and views. However, it is still missing quite a bit. 

The major things that currently need code contributions are:
- Database speed. The current database implementation is unreasonably slow.
- Variable/model management. The old version of the app downloads certain model contents directly from the web, and then caches them as the new defaults in the database. This allows the app to be "updated" without issuing a full update through the app store.
- Search/Filter display. The events display mechanism should be wrapped in a search/filter container.
- Maps and other info - download component. This component should download the map/model info from the web and store it in the database/app folder. Please see the Xamarin implementation for details.
- Maps and other info - display component. This should be a simple display method for the maps and other info. It should first check the app folder for any downloaded content, and then fall back to checking Resources (Android) or Contents (iOS) for the files in question.
- User event lists - display/edit component. This should be a display and edit method for User Event Lists. They should be cached offline in the existing database table.
- User event lists - upload/sync component. This should allow a user to post the user event list contents to a REST endpoint and receive a URL in response. Please see the existing Xamarin implementation for details.
- Documentation - this project is in need of production documentation.

If you have any IDEAS surrounding the above (anything you need resolved before you start coding), please open an issue and we'll discuss there.


Please make sure to document/comment and follow reasonable coding practices. Please also make sure that commits are concise and limited in scope to the thing they are meant to address. If you want to introduce a new feature, limit the pull request to that feature. If you want to make appearance changes, please limit the pull request to those changes. Do not combine the two requests into one.

### Other Contributions
The maps for 2019 must be completely made from scratch. We cannot use screenshots from the website. The contents (including names, room numbers, and other details) may be present on the maps, but they cannot be directly screen-shotted from the website. If you are interested in redrawing the maps, please do so!! You may submit a pull-request here or on the Xamarin version. Or, if you don't understand github, please send an email to SUPPORT @ VECTORLIT . NET and we will help you get what you need started.

### Web services and foundation support
There are several underlying REST web services which provide app state management, file downloads, user event list synchronization, and event downloads. The code for these services is not yet open source, but the services will remain available for use with this app. The endpoints are described in the code and are generally self-explanatory. If you have any issues or need changes for an update, please open an issue.

### A note about versions
This is the FLUTTER version of the app, and is an attempt to update the visuals and experience to a more modern one. If you would like to see the existing, production Xamarin code of the app, please visit https://github.com/vectorlit/UnofficialGenconMobile .

### Licensing
This code and resources are being distributed under the GPL-3.0 license. IF YOU USE THIS CODE, YOU HAVE A LEGAL REQUIREMENT TO ABIDE BY THE RULES SPECIFIED IN THE LICENSE.
