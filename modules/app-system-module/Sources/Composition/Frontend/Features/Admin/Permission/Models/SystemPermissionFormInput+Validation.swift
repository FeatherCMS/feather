import FeatherAdmin
import FeatherValidation

enum SystemPermissionFormFieldValidator {

    static func name(
        _ value: String?,
        required: Bool
    ) -> Validator<String> {
        .init(
            key: "name",
            value: value,
            required: required,
            invocation: .all,
            rules: []
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
            rules: []
        )
    }
}

extension SystemPermissionFormInput {

    private var validator: GroupValidator {
        GroupValidator {
            SystemPermissionFormFieldValidator.name(name, required: false)
            SystemPermissionFormFieldValidator.notes(notes, required: false)
        }
    }

    func validate() async throws(ValidationError) {
        try await validator.validate()
    }

    public func validationFailures() async -> [Failure] {
        await validator.failures()
    }
}
