import SwiftUI

let delegate = AppDelegate()

NSApplication.shared.delegate = delegate

_ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)

class AppDelegate: NSObject, NSApplicationDelegate {
  var statusBar: StatusBar?

  func applicationDidFinishLaunching(_ aNotification: Notification) {
    NSApp.setActivationPolicy(.accessory)
    statusBar = StatusBar()
  }
}

class StatusBar {
  private var statusItem: NSStatusItem

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
  
  init() {
    statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    statusItem.menu = appMenu
    statusItem.button!.image = NSImage(named: "AppIcon")
    statusItem.button!.image?.size = NSSize(width: 16.0, height: 16.0)
  }

  @objc private func aboutClicked() {
    NSApp.orderFrontStandardAboutPanel()
    NSApplication.shared.activate(ignoringOtherApps: true)
  }
}
