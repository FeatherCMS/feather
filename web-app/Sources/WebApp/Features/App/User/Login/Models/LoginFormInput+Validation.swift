import FeatherValidation
import FeatherValidationFoundation

enum LoginFormFieldValidator {

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

    static func password(
        _ value: String?,
        required: Bool
    ) -> Validator<String> {
        .init(
            key: "password",
            value: value,
            required: required,
            invocation: .all,
            rules: [
                .nonempty()
            ]
        )
    }
}

extension LoginFormInput {

    private var validator: GroupValidator {
        GroupValidator {
            LoginFormFieldValidator.email(email, required: true)
            LoginFormFieldValidator.password(password, required: true)
        }
    }

    func validate() async throws(ValidationError) {
        try await validator.validate()
    }

    func validationFailures() async -> [Failure] {
        await validator.failures()
    }
}
