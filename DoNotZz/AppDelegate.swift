//
//  AppDelegate.swift
//  DoNotZz
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    let activeImage = NSImage(named: "Enabled")
    let inactiveImage = NSImage(named: "Disabled")
    let enableItem = NSMenuItem()
    let disableItem = NSMenuItem()
    let keepAwakeOptions : ProcessInfo.ActivityOptions = [.userInitiated, .idleDisplaySleepDisabled, .idleSystemSleepDisabled]
    let info = ProcessInfo.processInfo
    
    var stayAwakeActivity: NSObjectProtocol?
    
    override init() {
        super.init()
        enableItem.title = "Enable"
        enableItem.isEnabled = true
        enableItem.keyEquivalent = "e"
        enableItem.action = #selector(self.startKeepAwake)
        
        disableItem.title = "Disable"
        disableItem.isEnabled = false
        disableItem.keyEquivalent = "d"
        disableItem.action = #selector(self.stopKeepAwake)
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        setStatusImage(image: inactiveImage)
        
        let quitItem = NSMenuItem()
        quitItem.title = "Quit"
        quitItem.keyEquivalent = "q"
        quitItem.action = #selector(self.quit)
        
        let menu = NSMenu()
        menu.autoenablesItems = false
        menu.addItem(enableItem)
        menu.addItem(disableItem)
        menu.addItem(NSMenuItem.separator())
        menu.addItem(quitItem)
        setStatusMenu(menu: menu)
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        stopKeepAwake(sender: self)
    }
    
    @objc func startKeepAwake(sender: AnyObject) {
        if stayAwakeActivity != nil {
            return
        }
        
        setStatusImage(image: activeImage)
        enableItem.isEnabled = false
        disableItem.isEnabled = true
        
        stayAwakeActivity = info.beginActivity(options: keepAwakeOptions, reason: "DoNotZz")
    }
    
    @objc func stopKeepAwake(sender: AnyObject) {
        if stayAwakeActivity == nil {
            return
        }
        
        setStatusImage(image: inactiveImage)
        enableItem.isEnabled = true
        disableItem.isEnabled = false
        
        info.endActivity(stayAwakeActivity!)
        stayAwakeActivity = nil
    }
    
    func setStatusImage(image: NSImage?) {
        if let button = statusItem.button {
            button.image = image
        }
    }
    
    func setStatusMenu(menu: NSMenu?) {
        statusItem.menu = menu
    }
    
    @objc func quit(sender: AnyObject) {
        NSApplication.shared.terminate(self)
    }
}
