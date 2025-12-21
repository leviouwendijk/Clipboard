#if os(macOS)
    import AppKit
#endif

extension NSAttributedString: NSAttributedStringCopyable {
    public func clipboard() {
        copyNSToClipboard(self)
    }

    public func nscp() {
        clipboard()
    }

    public func ns_copy() {
        clipboard()
    }

    @available(*, message: "will deprecate")
    public func nsCopy() {
        copyNSToClipboard(self)
    }
}
