import FeatherAdmin
import FeatherValidation

enum AdminAddUserRoleFormFieldValidator {

    static func name(
        _ value: String?,
        required: Bool
    ) -> Validator<String> {
        .init(
            key: "name",
            value: value,
            required: required,
            invocation: .all,
            rules: [
                .trimmedNonempty(message: "Name is required."),
                .min(
                    length: 4,
                    message: "Name must be at least 4 characters."
                ),
                .max(
                    length: 254,
                    message: "Name must be shorter than 255 characters."
                ),
            ]
        )
    }

    static func notes(
        _ value: String?,
        required: Bool
    ) -> Validator<String> {
        .init(
            key: "notes",
            value: value,
            required: required,
            invocation: .all,
            rules: [
                .max(
                    length: 254,
                    message: "Notes must be shorter than 255 characters."
                )
            ]
        )
    }
}

extension AdminAddUserRoleFormInput {

    private var validator: GroupValidator {
        GroupValidator {
            AdminAddUserRoleFormFieldValidator.name(name, required: true)
            AdminAddUserRoleFormFieldValidator.notes(notes, required: false)
        }
    }

    func validate() async throws(ValidationError) {
        try await validator.validate()
    }

    public func validationFailures() async -> [Failure] {
        await validator.failures()
    }
}
