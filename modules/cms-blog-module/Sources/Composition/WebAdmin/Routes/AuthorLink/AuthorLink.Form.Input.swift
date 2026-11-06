import BlogAdminAPI
import BlogAppAPI
import BlogModule
import FeatherModuleKit
import FeatherValidation
import FeatherWebAdmin
import HTML
import Hummingbird
import MediaWebAdmin
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebModuleWebAdmin

extension AuthorLink.Form {
    struct Input: Codable, Sendable, Equatable, Hashable {

        enum CodingKeys: String, CodingKey {
            case label
            case url
            case priority
            case isBlank
            case permission
            case notes
        }

        let label: String
        let url: String
        let priority: String
        let isBlank: AdminFormFieldCheckbox.Input
        let permission: String
        let notes: String

        init(
            label: String,
            url: String,
            priority: String,
            isBlank: AdminFormFieldCheckbox.Input,
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

        init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.label = try container.decode(String.self, forKey: .label)
            self.url = try container.decode(String.self, forKey: .url)
            self.priority = try container.decode(String.self, forKey: .priority)
            self.isBlank =
                try container.decodeIfPresent(
                    AdminFormFieldCheckbox.Input.self,
                    forKey: .isBlank
                ) ?? .init(value: false)
            self.permission = try container.decode(
                String.self,
                forKey: .permission
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

        var normalizedPermission: String {
            permission.whitespaceTrimmed
        }

        var normalizedNotes: String {
            notes.whitespaceTrimmed
        }

        var parsedPriority: Int? {
            Int(normalizedPriority)
        }
    }
}
