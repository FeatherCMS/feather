import FeatherAdmin
import FeatherContracts
import FeatherValidation
import Foundation

struct MediaVariantFormInput: Decodable, Sendable, Equatable, Hashable {
    let key: String
    let name: String
    let isRequired: NewAdminFormFieldCheckbox.Input
    let isActive: NewAdminFormFieldCheckbox.Input

    var normalizedKey: String {
        key.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    var normalizedName: String {
        name.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    init(
        key: String,
        name: String,
        isRequired: NewAdminFormFieldCheckbox.Input = .init(value: false),
        isActive: NewAdminFormFieldCheckbox.Input = .init(value: true)
    ) {
        self.key = key
        self.name = name
        self.isRequired = isRequired
        self.isActive = isActive
    }

    func validate() async throws(ValidationError) {
        try await GroupValidator {
            Validator(
                key: "key",
                value: key,
                required: true,
                invocation: .all,
                rules: [
                    .trimmedNonempty(message: "Key is required."),
                    .min(
                        length: 2,
                        message: "Key must be at least 2 characters."
                    ),
                    .max(
                        length: 254,
                        message: "Key must be shorter than 255 characters."
                    ),
                ]
            )
            Validator(
                key: "name",
                value: name,
                required: true,
                invocation: .all,
                rules: [
                    .trimmedNonempty(message: "Name is required."),
                    .max(
                        length: 254,
                        message: "Name must be shorter than 255 characters."
                    ),
                ]
            )
        }
        .validate()
    }
}
