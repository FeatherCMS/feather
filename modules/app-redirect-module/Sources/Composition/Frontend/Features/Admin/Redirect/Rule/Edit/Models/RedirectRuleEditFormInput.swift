import FeatherAdmin
import FeatherContracts
import RedirectContracts

public struct RedirectRuleEditFormInput: Decodable, Sendable, Equatable,
    Hashable
{

    public let source: String
    public let destination: String
    public let statusCode: String
    public let notes: String

    var normalizedSource: String {
        source.whitespaceTrimmed
    }

    var normalizedDestination: String {
        destination.whitespaceTrimmed
    }

    var normalizedStatusCode: String {
        statusCode.whitespaceTrimmed
    }

    var normalizedNotes: String {
        notes.whitespaceTrimmed
    }

    var parsedStatusCode: StatusCode? {
        guard let value = Int(normalizedStatusCode) else { return nil }
        return StatusCode(rawValue: value)
    }
}
