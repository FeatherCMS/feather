import FeatherValidation
import FeatherValidationFoundation

enum AdminEditAuthProfileFormFieldValidator {

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
        let hasValue = !(value ?? "")
            .trimmingCharacters(
                in: .whitespacesAndNewlines
            )
            .isEmpty
        return .init(
            key: "password",
            value: value,
            required: required,
            invocation: .all,
            rules: hasValue
                ? [
                    .trimmedNonempty(message: "Password is required."),
                    .min(length: 9, message: "Password is too short."),
                ]
                : []
        )
    }
}

extension AdminEditAuthProfileFormInput {

    private var validator: GroupValidator {
        GroupValidator {
            AdminEditAuthProfileFormFieldValidator.email(email, required: true)
            AdminEditAuthProfileFormFieldValidator.password(
                password,
                required: false
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
