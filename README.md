# MicroApp

A minimal skeleton for a very basic macOS app.

The only current functionality:

- Show a taskbar icon.
- Provide an About page.
- Provide a Quit option

This is all done via a single source file (main.swift) along a single
plist (Info.plist), the `Localizable.strings` file (`en` by default),
`entitlements`, and a trimmed-down `project.pbxproj` file with a
single release target.

And an icon, of course.

## Building

From the command line:

    xcodebuild build
    
This should place an app in `build/Release/MicroApp.app` that can be run with:

    open build/Release/MicroApp.app
