import BlogAdminAPI
import BlogAppAPI
import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaFrontend
import OpenAPIRuntime
import SGML
import WebFrontend
import WebStandards

public struct BlogAuthorLinkFormInput: Codable, Sendable, Equatable, Hashable {

    enum CodingKeys: String, CodingKey {
        case label
        case url
        case priority
        case isBlank
        case permission
        case notes
    }

    public let label: String
    public let url: String
    public let priority: String
    public let isBlank: CheckboxFormInput
    public let permission: String
    public let notes: String

    init(
        label: String,
        url: String,
        priority: String,
        isBlank: CheckboxFormInput,
        permission: String,
        notes: String
    ) {
        self.label = label
        self.url = url
        self.priority = priority
        self.isBlank = isBlank
        self.permission = permission
        self.notes = notes
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.label = try container.decode(String.self, forKey: .label)
        self.url = try container.decode(String.self, forKey: .url)
        self.priority = try container.decode(String.self, forKey: .priority)
        self.isBlank =
            try container.decodeIfPresent(
                CheckboxFormInput.self,
                forKey: .isBlank
            ) ?? .init(value: false)
        self.permission = try container.decode(String.self, forKey: .permission)
        self.notes = try container.decode(String.self, forKey: .notes)
    }

    var normalizedLabel: String {
        label.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var normalizedURL: String {
        url.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var normalizedPriority: String {
        priority.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var normalizedPermission: String {
        permission.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var normalizedNotes: String {
        notes.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var parsedPriority: Int? {
        Int(normalizedPriority)
    }
}
