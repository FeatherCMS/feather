import Foundation

public struct AdminStatusActionFormInput: Codable, Sendable, Equatable, Hashable
{
    public let returnTo: String?
    public let status: String

    public init(returnTo: String?, status: String) {
        self.returnTo = returnTo
        self.status = status
    }

    public var normalizedReturnTo: String? {
        let trimmed = returnTo?.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let trimmed, trimmed.hasPrefix("/admin/") else {
            return nil
        }
        return trimmed
    }

    public var normalizedStatus: String {
        status
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
    }
}
