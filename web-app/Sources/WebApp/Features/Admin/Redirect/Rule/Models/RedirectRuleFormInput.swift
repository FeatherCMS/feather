import Foundation

struct RedirectRuleFormInput: Codable, Sendable, Equatable, Hashable {

    let source: String
    let destination: String
    let statusCode: String
    let notes: String

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

    var parsedStatusCode: Int? {
        Int(normalizedStatusCode)
    }
}
