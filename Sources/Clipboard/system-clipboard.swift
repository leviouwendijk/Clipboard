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

        public func write(
            _ text: String
        ) {
            #if os(macOS)
                let pasteboard =
                    NSPasteboard.general

                pasteboard.clearContents()
                pasteboard.declareTypes(
                    [
                        .string,
                        .utf8PlainText,
                    ],
                    owner: nil
                )

                _ = pasteboard.setString(
                    text,
                    forType: .string
                )

                if let data = text.data(
                    using: .utf8
                ) {
                    _ = pasteboard.setData(
                        data,
                        forType: .utf8PlainText
                    )
                }
            #elseif canImport(UIKit)
                UIPasteboard.general.string =
                    text
            #else
                // Unsupported platform: no-op
            #endif
        }
    }
}
