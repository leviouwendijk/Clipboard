extension String: StringCopyable {
    public func clipboard() -> Void {
        copyToClipboard(self)
    }

    public func scp() {
        clipboard()
    }

    public func s_copy() {
        clipboard()
    }

    @available(*, message: "will deprecate")
    public func sCopy() {
        copyToClipboard(self)
    }
}
