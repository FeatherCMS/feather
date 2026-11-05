import FeatherValidation
import FeatherWebAdmin
import UserModule

extension Role.Edit.Form {
    enum FieldValidator {

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
}

extension Role.Edit.Form.Input {

    private var validator: GroupValidator {
        GroupValidator {
            Role.Edit.Form.FieldValidator.name(name, required: true)
            Role.Edit.Form.FieldValidator.notes(notes, required: false)
        }
    }

    func validate() async throws(ValidationError) {
        try await validator.validate()
    }

    func validationFailures() async -> [Failure] {
        await validator.failures()
    }
}
