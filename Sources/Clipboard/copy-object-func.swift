import Foundation

#if os(macOS)
    import AppKit
#elseif canImport(UIKit)
    import UIKit
#endif

public func copyFileObjectToClipboard(path file: String) throws {
    guard FileManager.default.fileExists(atPath: file) else {
        throw CopyClipboardError.fileNotFound("No file found at path: \(file)")
    }

    let fileURL = URL(fileURLWithPath: file)

    #if os(macOS)
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()

        let success = pasteboard.writeObjects([fileURL as NSURL])

        if success {
            print("File copied to clipboard as a file reference.")
        } else {
            throw CopyClipboardError.copyFailure("Failed to copy file to clipboard.")
        }
    #elseif canImport(UIKit)
        let pasteboard = UIPasteboard.general
        pasteboard.url = fileURL
        // alternative: `pasteboard.items` with "public.file-url" 
        // pasteboard.items = [["public.file-url": fileURL.absoluteString.data(using: .utf8) ?? Data()]]
    #else
        throw CopyClipboardError.copyFailure("Clipboard file copy is unsupported on this platform.")
    #endif
}
