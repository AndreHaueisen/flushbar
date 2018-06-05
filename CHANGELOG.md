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