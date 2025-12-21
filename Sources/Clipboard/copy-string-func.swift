import Foundation

#if os(macOS)
    import AppKit
#elseif canImport(UIKit)
    import UIKit
#endif

public func copyToClipboard(_ text: String) {
    #if os(macOS)
        let pb = NSPasteboard.general
        pb.clearContents()
        // Explicit multi-type (string + utf8-plain-text)
        pb.declareTypes([.string, .utf8PlainText], owner: nil)
        _ = pb.setString(text, forType: .string)
        if let data = text.data(using: .utf8) {
            _ = pb.setData(data, forType: .utf8PlainText)
        }
    #elseif canImport(UIKit)
        UIPasteboard.general.string = text
    #else
        // Unsupported platform: no-op
    #endif
}
