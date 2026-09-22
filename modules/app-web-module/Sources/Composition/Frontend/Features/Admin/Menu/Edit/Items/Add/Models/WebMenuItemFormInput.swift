import FeatherAdmin
import FeatherContracts
import OpenAPIRuntime

public struct WebMenuItemFormInput: Codable, Sendable, Equatable, Hashable {

    enum CodingKeys: String, CodingKey {
        case label
        case url
        case priority
        case isBlank
        case permission
        case authentication
        case notes
    }

    public let label: String
    public let url: String
    public let priority: String
    public let isBlank: NewAdminFormFieldCheckbox.Input
    public let permission: String
    public let authentication: String
    public let notes: String

    init(
        label: String,
        url: String,
        priority: String,
        isBlank: NewAdminFormFieldCheckbox.Input,
        permission: String,
        authentication: String,
        notes: String
    ) {
        self.label = label
        self.url = url
        self.priority = priority
        self.isBlank = isBlank
        self.permission = permission
        self.authentication = authentication
        self.notes = notes
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.label = try container.decode(String.self, forKey: .label)
        self.url = try container.decode(String.self, forKey: .url)
        self.priority = try container.decode(String.self, forKey: .priority)
        self.isBlank =
            try container.decodeIfPresent(
                NewAdminFormFieldCheckbox.Input.self,
                forKey: .isBlank
            ) ?? .init(value: false)
        self.permission = try container.decode(String.self, forKey: .permission)
        self.authentication = try container.decode(
            String.self,
            forKey: .authentication
        )
        self.notes = try container.decode(String.self, forKey: .notes)
    }

    var normalizedLabel: String {
        label.whitespaceTrimmed
    }

    var normalizedURL: String {
        url.whitespaceTrimmed
    }

    var normalizedPriority: String {
        priority.whitespaceTrimmed
    }

    var normalizedAuthentication: String {
        authentication.whitespaceTrimmed
    }

    var normalizedNotes: String {
        notes.whitespaceTrimmed
    }

    var parsedPriority: Int? {
        Int(normalizedPriority)
    }
}
