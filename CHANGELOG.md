## [1.10.2] - 2020-07-05
- Fixes SDK version

## [1.10.1] - 2020-07-05
- With FLutter's 1.17 release, Flushbar 1.10 is now compatible with stable channel

## [1.10.0] - 2020-25-03
- **Breaking change** fixes a breaking change introduced by Flutter. Only use this version if you are using flutter v1.15 or greater (currently on the beta channel)
- **Breaking change** adds blockBackgroundInteraction property.
- **Breaking change** overlayBlur renamed to routeBlur. Will be ignored if blockBackgroundInteraction is false
- **Breaking change** overlayColor renamed to routeColor. Will be ignored if blockBackgroundInteraction is false
- Now, if [showProgressIndicator] is true and [progressIndicatorController] is null, an infinite linear progress indicator will be shown
- Performance improvements
- Code refactoring

## [1.9.1] - 2019-21-10
- Fixed shadows not showing up

## [1.9.0] - 2019-01-09
- Added `maxWidth` property
- Added `barBlur` which applies a BackdropFilter only to Flushbar's background
- Default animation curve changed from `fastOutSlowIn` to `easeOutCirc`

## [1.8.2] - 2019-02-08
- Blur overlay is now dismissible by click if `isDismissible == true`
- Blur overlay will now animate until it disappears instead of vanishing

## [1.8.1] - 2019-29-07
- Removed context requirement from flushbar_route
- Fix onTap requiring a return value

## [1.8.0] - 2019-17-07
- **Breaking Change** renamed `aroundPadding` to `margin`
- Flushbar now supports uniform borders (same border on all sides)
- Added `borderColor` property
- Added `borderWidth` property
- Added `padding` property - default still complies with material design specs

## [1.7.1+1] - 2019-10-07
- Fixed environment variables

## [1.7.1] - 2019-10-07
- Changed file docs to comply with dartdoc directives
- Flutter minimum version for Flushbar is now 1.7.8
- With Flutter version 1.7.8 hitting stable, there is no version restriction for stable channel users anymore

## [1.7.0] - 2019-05-06
- add onTap property
- fix exception caused by user dismissal while flushbar is appearing or hiding

## [1.6.0] - 2019-31-05
- **breaking change** this fixes `The method 'detach' isn't defined for the class 'FocusScopeNode'`

## [1.5.3] - 2019-27-05
- update README file

## [1.5.2] - 2019-26-05
- `titleText` and `messageText` are now widgets so users can use `RichText` or `Text`
- Add `shouldIconPulse` property

## [1.5.0] - 2019-04-05
- **Breaking Change** boxShadow is now called boxShadows and is a List<BoxShadow>

## [1.4.0] - 2019-08-04
- Add `overlayBlur` property that pushes an overlay blocking user input on the background. Only takes effect if greater then 0.0
- Add `overlayColor` property that changes the overlay color. Default is transparent. Only takes effect if overlayBlur is greater then 0.0
- Create new file for FlushbarRoute

## [1.3.1] - 2019-02-04
- Constructor now has strongly typed parameters (my bad for forgetting it)
- Improved null message error

## [1.3.0] - 2019-14-03
- **Breaking Change** expect for `onStatusChanged`, all properties are now final. Two dot notation does 
not work anymore. Since you can only use the instance one time, this
is the best practice.
- Add `dismissDirection` property.
- **Behaviour change** dismiss is now vertical by default. This is more natural since 
Flushbar show animation is also vertical.
- It is now possible to dismiss a Flushbar that is not the top route. 
The only inconvenient is that it will not animate back (simply disappear) and the listener, if used, will not register the dismissal.
- Updated README file

## [1.2.4] - 2019-05-03
- Added FlushbarStyle.FLOATING & FlushbarStyle.GROUNDED
- Fixed icon animation being started even if icon is null

## [1.2.3] - 2019-25-02
- **Breaking Change** Flushbar now accepts a BoxShadow for a more customized shadow

## [1.2.2] - 2019-22-02
- Fixed a bug when push an route after flushbar, and flushbar timer pop the current route out

## [1.2.1] - 2019-11-01
- aroundPadding is now more flexible and receives EdgeInsets instead of an int

## [1.2.0] - 2018-09-12
- add animationDuration argument. You can now control how long does it take to show and dismiss Flushbar

## [1.1.2] - 2018-24-10
- icon argument can now be any widget, though I recommend using Icon or Image
- added null checks

## [1.1.1] - 2018-17-10

- Fixed bug where calling Navigator.push() on Flushbar swipe dismissal did not pop the route
- Fixed bug where swipe to dismiss a padded Flushbar caused to being stuck at the edge

## [1.1.0] - 2018-11-10

- Added two new features: aroundPadding and borderRadius
- Fixed a bug where the overlay background was not null

## [1.0.1] - 2018-11-02

- Texts now respond to alignment

## [1.0.0] - 2018-11-02

- No changes. Simply reached stable after a month without new bugs

## [0.9.2] - 2018-09-29

### Changes

- Dismissing a Flushbar that is not the top route no longer throws an exception
- Dismissing a Flushbar that is not the top route has the following effects:
   * It does not animate back. It simply vanishes
   * FlushbarStatus listener will not register `FlushbarStatus.IS_HIDING` or `FlushbarStatus.DISMISSED`
   * It returns no value when the Future yield by `dismiss()` completes

### Fixes

- Fixed an issue where a dismissible Flushbar would not cancel the timer and pop two routes instead of one

## [0.9.1] - 2018-09-25

### Changes

- Fixed an issue where Flushbar could get stuck when swipe to dismiss was used
- Minor layout tweeks
- Flushbar gets a weird logo! Do not judge me. I'm not a designer :)
- README file update
- README file fixes

## [0.9.0] - 2018-09-10

Looking good for version 1.0. Please, report any issues your have.

### Changes

- **IMPORTANT** `dismiss()` now returns a future when the animation is completed and route is poped. That makes it easier to concatenate two or more Flushbars.
- Major changes on how `show` and `dismiss` animations work, making Flushbar more reliable.
- Trying to `dismiss()` a Flushbar that is not the top route is going to throw an error.
- Pressing the back button will now properly `dismiss()` Flushbar.
- Performance improvements. In and out animations are smoother.

### Layout Changes

- Removed top padding when `flushbarPosition == FlushbarPosition.TOP`

## [0.8.3] - 2018-09-07

### Fixes

- Fixed issue when `isDismissible` is set to false [Issue #6](https://github.com/AndreHaueisen/flushbar/issues/6#issue-357423067)
- Fixed issue where the keyboard would hide Flushbar [Issue #7](https://github.com/AndreHaueisen/flushbar/issues/7#issue-357946307)

## [0.8.2] - 2018-08-27

### Changes

- Add `key` property
- Fixed bug here using flushbar_helper progressIndicator did not show
- Fixed documentation about progressIndicator

## [0.8.1] - 2018-08-12

### Changes

- Fixed Dart version issue

## [0.8.0] - 2018-08-11
### Breaking changes
- Changed the behaviour of linearProgressIndicator to allow the user to controll its progress. See README.md for examples
### Changes
- Added a left vertical bar to better convey the humor of the notification. See README.md for examples
- Title is not mandatory anymore

## [0.7.6] - 2018-08-07
### Changes
- Version update to supprt master channel

## [0.7.5] - 2018-07-28
### Changes
- Fix bug where keyboard did not show when using a Form
- Flushbar is now compatible with the master channel
- Bug fixes

## [0.7.1] - 2018-07-08
### Changes
- Flushbar doc update

## [0.7.0] - 2018-07-08
### Breaking changes
- Flushbar does not need a global instance anymore
- Flushbar it now made be used only one time. After it hits the dismissed state, that instance wont work anymore
- Due to the behaviour above, there is no need to call commitChanges() anymore
- Flushbar does not need to be within a Stack widget anymore
- Purged state eliminated
- FlushbarMorph is now called FlushbarHelper

### Changes
- README.md is updated

### Known issues
- When using a Form, the keyboard is not shown. Still figuring out how to solve it.

## [0.5.6] - 2018-06-20
### Changed
- Fixed dependency issue

## [0.5.5] - 2018-06-20
### Changed
- Updated flushbar_morph
- Updated sdk version

## [0.5.4] - 2018-06-16
### Changed
- Flushbar now animates size changes when commit is called while showing
- Layout refinements

## [0.5.2] - 2018-06-05
### Changed
- User input now receives a Form to facilitate field validation

## [0.5.1] - 2018-06-05
### Changed
- Fixed brain fart. Same changes as 0.5.0

## [0.5.0] - 2018-06-05
### Changed
- Removed change...() functions. Cascade notation is now recommended
- Update readme file
- Default message font size reduced from 16.0 to 14.0
- Default title font size reduced from 16.0 to 15.0

## [0.4.7] - 2018-06-04
### Changed
- Fixed bug with bar duration
- Blink animation when Flushbar is not dismissed now animates the whole bar
and is synchronised with content change.

## [0.4.5] - 2018-06-03
### Added
- Blink animation when commitChanges() is called when Flushbar is not dismissed. This provides a 
smooth content transition
- Helper class to morph Flushbar (FlushbarMorph)
### Changed
- Code cleanup

## [0.4.0] - 2018-05-27
### Added
- InputTextField

## [0.3.1] - 2018-05-27
### Changed
- Fixed bar being automatically called
- Title and message are not required at construction time
- Better usage example
- Removed callback from constructor

## [0.3.0] - 2018-05-27
### Changed
- Removed the possibility to chose icon position
- Widgets are now aligned correctly
- Documentation improvements

## [0.2.5] - 2018-05-26
### Changed
- Bug fixes
- Moved icon animation into the flushbar
- changeStatusListener() is now activated on change

## [0.2.0] - 2018-05-24
### Added
- Removed requirement for a initial widget
- OnStatusChanged callback so it is possible to listen to the various Flushbar status
- The callback can be changed using changeStatusListener()
- Started working on the README.md file

### Changed
- IconAwareAnimation is now more general and it is called PulseAnimator
- Flushbar now accepts an Icon instead of only the IconData and IconColor
- Alignment changes
- Default background color

## [0.0.1] - 2018-05-23
             
### Added
- Flushbar creation
- Single button action
- Status listeners
- Left or right icon positioning
- Top or bottom positioning