import FeatherValidation
import FeatherValidationFoundation

enum AdminAddUserAccountFormFieldValidator {

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
                .trimmedNonempty(message: "Password is required."),
                .min(length: 9, message: "Password is too short."),
            ]
        )
    }
}

extension AdminAddUserAccountFormInput {

    private var validator: GroupValidator {
        GroupValidator {
            AdminAddUserAccountFormFieldValidator.email(email, required: true)
            AdminAddUserAccountFormFieldValidator.password(
                password,
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
