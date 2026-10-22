import AccountModule
public import FeatherValidation
import FeatherValidationFoundation

private enum InvitationAddFormValidator {

    static func email(
        _ value: String?,
        required: Bool
    ) -> Validator<String> {
        .init(
            key: "email",
            value: value,
            required: required,
            invocation: .all,
            rules: [
                .trimmedNonempty(message: "Email is required."),
                .email(message: "Email is invalid."),
            ]
        )
    }
}

extension Invitation.Add.Form.Input {

    private var validator: GroupValidator {
        GroupValidator {
            InvitationAddFormValidator.email(
                email,
                required: true
            )
        }
    }

    func validate() async throws(ValidationError) {
        try await validator.validate()
    }

    public func validationFailures() async -> [Failure] {
        await validator.failures()
    }
}
