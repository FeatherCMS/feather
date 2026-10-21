import FeatherModuleKit
import RedirectModule

public struct RedirectRuleAddFormInput: Decodable, Sendable, Equatable, Hashable
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

    var parsedStatusCode: RedirectModule.Rule.StatusCode? {
        guard let value = Int(normalizedStatusCode) else { return nil }
        return RedirectModule.Rule.StatusCode(rawValue: value)
    }
}
