import FeatherAdmin
import FeatherValidation

enum AdminAddUserRoleFormFieldValidator {

    static func id(
        _ value: String?,
        required: Bool
    ) -> Validator<String> {
        .init(
            key: "id",
            value: value,
            required: required,
            invocation: .all,
            rules: [
                .trimmedNonempty(message: "ID is required.")
            ]
        )
    }

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
                .trimmedNonempty(message: "Name is required.")
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
            rules: []
        )
    }
}

extension AdminAddUserRoleFormInput {

    private var validator: GroupValidator {
        GroupValidator {
            AdminAddUserRoleFormFieldValidator.id(id, required: true)
            AdminAddUserRoleFormFieldValidator.name(name, required: false)
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
