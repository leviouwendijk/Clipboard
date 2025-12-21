import Foundation

public enum CopyClipboardError: Error {
    case fileNotFound(String)
    case copyFailure(String)
}
