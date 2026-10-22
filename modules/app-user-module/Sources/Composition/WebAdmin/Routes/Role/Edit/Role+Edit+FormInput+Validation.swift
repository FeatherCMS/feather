import FeatherValidation
import FeatherWebAdmin
import UserModule

extension Role.Edit {
    enum FormFieldValidator {

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

    extension Role.Edit.FormInput {

    private var validator: GroupValidator {
        GroupValidator {
            Role.Edit.FormFieldValidator.name(name, required: true)
            Role.Edit.FormFieldValidator.notes(notes, required: false)
        }
    }

    func validate() async throws(ValidationError) {
        try await validator.validate()
    }

    func validationFailures() async -> [Failure] {
        await validator.failures()
    }
}
