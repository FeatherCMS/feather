import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct ContactFormFieldAddForm: Decodable {
    var key: String = ""
    var type: String = "text"
    var label: String = ""
    var allowedValues: String = ""
    var isRequired: CheckboxFormInput = .init(value: false)

    enum CodingKeys: String, CodingKey {
        case key
        case type
        case label
        case allowedValues
        case isRequired
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        key = try container.decode(String.self, forKey: .key)
        type = try container.decode(String.self, forKey: .type)
        label = try container.decode(String.self, forKey: .label)
        allowedValues = try container.decode(
            String.self,
            forKey: .allowedValues
        )
        isRequired =
            try container.decodeIfPresent(
                CheckboxFormInput.self,
                forKey: .isRequired
            ) ?? .init(value: false)
    }

    var isRequiredValue: Bool { isRequired.value }
    var position: String = "0"
    var normalizedAllowedValues: [String] {
        allowedValues.split(separator: "\n")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }
    var normalizedPosition: Int { Int(position) ?? 0 }
}
