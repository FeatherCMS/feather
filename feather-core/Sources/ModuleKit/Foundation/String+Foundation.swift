import Foundation

extension StringProtocol {
    public var whitespaceTrimmed: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

