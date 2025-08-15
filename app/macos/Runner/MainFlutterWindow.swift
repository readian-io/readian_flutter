import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
    
    // Set minimum window size (iPhone 12 dimensions)
    self.minSize = NSSize(width: 390, height: 844)
    
    // Optional: Set default window size if current is smaller
    let currentSize = self.frame.size
    if currentSize.width < 390 || currentSize.height < 844 {
      self.setFrame(NSRect(x: self.frame.origin.x, y: self.frame.origin.y, width: 390, height: 844), display: true)
    }
  }
}
