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
    let aboutWindow = NSApp.windows.first { $0 is About } ?? About()
    Closer.add(aboutWindow)
  }
  
  @objc private func quitClicked() {
    NSApplication.shared.terminate(self)
  }
}

// Keep track of open windows, set us as accessory when last one is gone.
class Closer {
  internal static var windows: Set<NSWindow> = []

  // Add window, make the app active.
  static func add<T: NSWindow>(_ window: T) {
    windows.insert(window)
    NSApp.setActivationPolicy(.regular)
    NSApplication.shared.activate(ignoringOtherApps: true)
    window.makeKeyAndOrderFront(nil)
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(windowWillClose),
      name: NSWindow.willCloseNotification,
      object: window)
  }

  @objc static func windowWillClose(_ notification: NSNotification) {
    let window = notification.object as! NSWindow
    NotificationCenter.default.removeObserver(self)
    for win in windows {
      if win == window {
        windows.remove(window)
        if windows.count == 0 { // All gone, hide our menu and dock entry.
          NSApp.setActivationPolicy(.accessory)
        }
        return
      }
    }
  }
}

final class About: NSWindow {
  @discardableResult init() {
    super.init(contentRect: .init(), styleMask: [.closable, .titled, .miniaturizable], backing: .buffered, defer: false)
    title = NSLocalizedString("About.title", comment: "")
    isReleasedWhenClosed = false
    level = .floating
    contentView = NSHostingView(rootView: AboutContents())
    center()
  }
}

struct AboutContents: View {
  var image: NSImage
  init() {
    image = NSImage(named: "AppIcon")!.copy() as! NSImage
    image.size = NSSize(width: 256.0, height: 256.0)
  }
  var body: some View {
    VStack {
      Image(nsImage: image)
      Text(NSLocalizedString("About.text", comment: ""))
    }
      .padding()
  }
}
