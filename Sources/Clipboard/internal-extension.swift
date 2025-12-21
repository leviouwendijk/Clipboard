#if os(macOS)
    import AppKit
#elseif canImport(UIKit)
    import UIKit
#endif

#if os(macOS)
    internal extension NSPasteboard.PasteboardType {
        static let utf8PlainText = NSPasteboard.PasteboardType("public.utf8-plain-text")
    }
#endif
