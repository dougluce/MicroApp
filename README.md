# MicroApp

A minimal skeleton for a very basic macOS app.

Current functionality:

- Show a taskbar icon.
- Provide an About page.
- Provide a Quit option

This is all done via one Swift source file (`main.swift`) alongside
`Info.plist`, the `Localizable.strings` file (`en` by default),
`entitlements`, and a trimmed-down `project.pbxproj` file with a
single release target.

There's also an icon and a credits file ready for editing.

## Building

From the command line:

    xcodebuild build
    
This should place an app in `build/Release/MicroApp.app` that can be run with:

    open build/Release/MicroApp.app
