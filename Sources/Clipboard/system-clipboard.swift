import Foundation

#if os(macOS)
    import AppKit
#elseif canImport(UIKit)
    import UIKit
#endif

public enum Clipboard {
    public static let system =
        SystemClipboard()

    public struct SystemClipboard:
        Sendable
    {
        public func read() -> String? {
            #if os(macOS)
                NSPasteboard.general.string(
                    forType: .string
                )
            #elseif canImport(UIKit)
                UIPasteboard.general.string
            #else
                nil
            #endif
        }

        @discardableResult
        public func write(
            _ text: String
        ) -> Bool {
            #if os(macOS)
                let pasteboard =
                    NSPasteboard.general

                pasteboard.clearContents()

                return pasteboard.writeObjects(
                    [
                        text as NSString,
                    ]
                )
            #elseif canImport(UIKit)
                UIPasteboard.general.string =
                    text

                return true
            #else
                return false
            #endif
        }
    }
}
