import FeatherAdmin
import FeatherContracts
import OpenAPIRuntime

public struct WebMenuFormInput: Codable, Sendable, Equatable, Hashable {

    public let key: String
    public let name: String
    public let notes: String

    var normalizedKey: String {
        key.whitespaceTrimmed
    }

    var normalizedName: String {
        name.whitespaceTrimmed
    }

    var normalizedNotes: String {
        notes.whitespaceTrimmed
    }
}
