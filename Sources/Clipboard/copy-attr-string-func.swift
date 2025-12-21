import Foundation

#if os(macOS)
    import AppKit
#elseif canImport(UIKit)
    import UIKit
#endif

public func copyNSToClipboard(_ attributedString: NSAttributedString) {
    #if os(macOS)
        let pb = NSPasteboard.general
        pb.clearContents()

        var declared: [NSPasteboard.PasteboardType] = []

        if let rtf = try? attributedString.data(
            from: NSRange(location: 0, length: attributedString.length),
            documentAttributes: [.documentType: NSAttributedString.DocumentType.rtf]
        ) {
            declared.append(.rtf)
            pb.declareTypes([.rtf], owner: nil)
            _ = pb.setData(rtf, forType: .rtf)
        }

        let text = attributedString.string

        if !declared.isEmpty {
            _ = pb.setString(text, forType: .string)
            if let data = text.data(using: .utf8) {
                _ = pb.setData(data, forType: .utf8PlainText)
            }
        } else {
            // Fallback path: declare plain text types
            pb.declareTypes([.string, .utf8PlainText], owner: nil)
            _ = pb.setString(text, forType: .string)
            if let data = text.data(using: .utf8) {
                _ = pb.setData(data, forType: .utf8PlainText)
            }
        }
    #elseif canImport(UIKit)
        let pb = UIPasteboard.general
        let text = attributedString.string

        // Try to preserve rich text via RTF; always include UTF-8 plain text
        if let rtf = try? attributedString.data(
            from: NSRange(location: 0, length: attributedString.length),
            documentAttributes: [.documentType: NSAttributedString.DocumentType.rtf]
        ) {
            pb.items = [[
                "public.rtf": rtf,
                "public.utf8-plain-text": text.data(using: .utf8) ?? Data()
            ]]
        } else {
            pb.string = text
        }
    #else
        // Unsupported platform: no-op
    #endif
}
