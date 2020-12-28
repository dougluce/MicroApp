import Cocoa
import AppKit
import SwiftUI

let delegate = AppDelegate()

NSApplication.shared.delegate = delegate

_ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)

class AppDelegate: NSObject, NSApplicationDelegate {
  var statusBar: StatusBar?

  func applicationDidFinishLaunching(_ aNotification: Notification) {
    NSApp.setActivationPolicy(.accessory)
    statusBar = StatusBar.init()

    let appMenuItem = NSMenuItem()
    appMenuItem.submenu = AppMenu(showKeys: true)

    let mainMenu = NSMenu()
    mainMenu.addItem(appMenuItem)

    NSApp.mainMenu = mainMenu
  }
}

class StatusBar {
  private var statusItem: NSStatusItem
  
  init() {
    statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    statusItem.menu = AppMenu(showKeys: false)
    
    if let statusBarButton = statusItem.button {
      statusBarButton.image = (NSImage(named: "AppIcon")!.copy() as! NSImage)
      statusBarButton.image?.size = NSSize(width: 16.0, height: 16.0)
    }
  }
}

class AppMenu: NSMenu {
  var showKeys = true

  required init(coder: NSCoder) {
    super.init(coder: coder)
    updateMenu()
  }
  
  init(showKeys: Bool) {
    self.showKeys = showKeys
    super.init(title: "MicroApp")
    updateMenu()
  }
  
  private func updateMenu() {
    self.removeAllItems()
    buildMenu()
  }
  
  private func buildMenu() {
    let appName = ProcessInfo.processInfo.processName
    let aboutItem = NSMenuItem(title: "About \(appName)", action: #selector(aboutClicked), keyEquivalent: showKeys ? "a" : "")
    aboutItem.target = self
    addItem(aboutItem)
    addItem(NSMenuItem.separator())
    let quitItem = NSMenuItem(title: "Quit \(appName)", action: #selector(quitClicked), keyEquivalent: showKeys ? "q" : "")
    quitItem.target = self
    addItem(quitItem)
  }
  
  @objc private func aboutClicked() {
    NSApp.orderFrontStandardAboutPanel()
    NSApplication.shared.activate(ignoringOtherApps: true)
  }
  
  @objc private func quitClicked() {
    NSApplication.shared.terminate(self)
  }
}
