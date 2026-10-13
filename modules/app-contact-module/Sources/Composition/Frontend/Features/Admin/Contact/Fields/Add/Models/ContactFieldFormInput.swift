import FeatherAdmin
import FeatherContracts
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

public struct ContactFieldFormInput: Decodable, Sendable {
    var key: String = ""
    var type: String = "text"
    var label: String = ""
    var allowedValues: [String] = []
    var isRequired: NewAdminFormFieldCheckbox.Input = .init(value: false)

    enum CodingKeys: String, CodingKey {
        case key
        case type
        case label
        case allowedValues
        case isRequired
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        key = try container.decode(String.self, forKey: .key)
        type = try container.decode(String.self, forKey: .type)
        label = try container.decode(String.self, forKey: .label)
        allowedValues =
            try container.decodeIfPresent(
                [String].self,
                forKey: .allowedValues
            ) ?? []
        isRequired =
            try container.decodeIfPresent(
                NewAdminFormFieldCheckbox.Input.self,
                forKey: .isRequired
            ) ?? .init(value: false)
    }

    var isRequiredValue: Bool { isRequired.value }
    var position: String = "0"
    var normalizedAllowedValues: [String] {
        allowedValues
            .map { $0.whitespaceTrimmed }
            .filter { !$0.isEmpty }
    }
    var allowedValuesValidationError: String? {
        switch type {
        case "select", "radio":
            guard normalizedAllowedValues.isEmpty else { return nil }
            return "Allowed values are required for select and radio fields."
        case "text", "textarea", "toggle", "hidden":
            guard !normalizedAllowedValues.isEmpty else { return nil }
            return
                "Allowed values can only be used with select and radio fields."
        default:
            return nil
        }
    }
    var normalizedPosition: Int { Int(position) ?? 0 }
}
