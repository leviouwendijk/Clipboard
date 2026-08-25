public func copyToClipboard(
    _ text: String
) {
    Clipboard.system.write(
        text
    )
}
