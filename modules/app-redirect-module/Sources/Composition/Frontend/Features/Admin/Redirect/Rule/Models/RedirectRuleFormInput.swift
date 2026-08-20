import FeatherAdmin
import Foundation
import RedirectContracts

public struct RedirectRuleFormInput: Codable, Sendable, Equatable, Hashable {

    public let source: String
    public let destination: String
    public let statusCode: String
    public let notes: String

    var normalizedSource: String {
        source.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var normalizedDestination: String {
        destination.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var normalizedStatusCode: String {
        statusCode.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var normalizedNotes: String {
        notes.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var parsedStatusCode: StatusCode? {
        guard let value = Int(normalizedStatusCode) else { return nil }
        return StatusCode(rawValue: value)
    }
}
