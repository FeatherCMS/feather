import FeatherAdmin
import Foundation
import OpenAPIRuntime

public struct WebMenuFormInput: Codable, Sendable, Equatable, Hashable {

    public let key: String
    public let name: String
    public let notes: String

    var normalizedKey: String {
        key.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var normalizedName: String {
        name.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var normalizedNotes: String {
        notes.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
