import SwiftUI

let delegate = AppDelegate()

NSApplication.shared.delegate = delegate

_ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)

class AppDelegate: NSObject, NSApplicationDelegate {
  lazy var appMenu: NSMenu = {
    let menu = NSMenu()
    let appName = ProcessInfo.processInfo.processName
    let aboutItem = NSMenuItem(title: "About \(appName)", action: #selector(aboutClicked), keyEquivalent: "")
    aboutItem.target = self
    menu.addItem(aboutItem)
    menu.addItem(NSMenuItem.separator())
    menu.addItem(NSMenuItem(title: "Quit \(appName)", action: #selector(NSApplication.terminate(_:)), keyEquivalent: ""))
    return menu
  }()

  lazy var statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)

  @objc private func aboutClicked() {
    NSApp.orderFrontStandardAboutPanel()
    NSApplication.shared.activate(ignoringOtherApps: true)
  }

  func applicationDidFinishLaunching(_ aNotification: Notification) {
    statusItem.menu = appMenu
    statusItem.button!.image = NSImage(named: "AppIcon")
    statusItem.button!.image?.size = NSSize(width: 16.0, height: 16.0)
  }
}
