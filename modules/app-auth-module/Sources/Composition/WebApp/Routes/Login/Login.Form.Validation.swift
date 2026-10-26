public import FeatherValidation
import FeatherValidationFoundation

extension Login.Form {
    enum Validator {

        static func email(
            _ value: String?,
            required: Bool
        ) -> FeatherValidation.Validator<String> {
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
        ) -> FeatherValidation.Validator<String> {
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
}

extension Login.Form.Input {

    private var validator: GroupValidator {
        GroupValidator {
            Login.Form.Validator.email(email, required: true)
            Login.Form.Validator.password(password, required: true)
        }
    }

    func validate() async throws(ValidationError) {
        try await validator.validate()
    }

    public func validationFailures() async -> [Failure] {
        await validator.failures()
    }
}
