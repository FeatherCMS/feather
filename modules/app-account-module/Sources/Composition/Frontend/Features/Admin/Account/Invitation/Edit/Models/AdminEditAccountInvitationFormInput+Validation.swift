import FeatherAdmin
import FeatherValidation
import FeatherValidationFoundation

enum AdminEditAccountInvitationFormFieldValidator {

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

extension AdminEditAccountInvitationFormInput {

    private var validator: GroupValidator {
        GroupValidator {
            AdminEditAccountInvitationFormFieldValidator.email(
                email,
                required: true
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
