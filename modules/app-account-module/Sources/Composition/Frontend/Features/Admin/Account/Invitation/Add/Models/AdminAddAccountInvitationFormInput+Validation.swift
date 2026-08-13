import FeatherAdmin
import FeatherValidation
import FeatherValidationFoundation

enum AdminAddAccountInvitationFormFieldValidator {

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

extension AdminAddAccountInvitationFormInput {

    private var validator: GroupValidator {
        GroupValidator {
            AdminAddAccountInvitationFormFieldValidator.email(
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
