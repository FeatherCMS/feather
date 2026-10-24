import AccountModule
import FeatherValidation
import FeatherValidationFoundation

extension Invitation.Edit.Form.Input {

    private var validator: GroupValidator {
        GroupValidator {
            Validator<String>(
                key: "email",
                value: email,
                required: true,
                invocation: .all,
                rules: [
                    .trimmedNonempty(message: "Email is required."),
                    .email(message: "Email is invalid."),
                ]
            )
        }
    }

    func validate() async throws(ValidationError) {
        try await validator.validate()
    }

    func validationFailures() async -> [Failure] {
        await validator.failures()
    }
}
