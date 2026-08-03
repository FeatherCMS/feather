import Foundation
import FeatherValidation
import FeatherValidationFoundation

enum AdminAuthCredentialFormValidation {
    static func email(_ value: String?) -> Validator<String> {
        .init(
            key: "email",
            value: value,
            required: true,
            invocation: .all,
            rules: [
                .trimmedNonempty(message: "Email is required."),
                .email(message: "Email is invalid."),
            ]
        )
    }

    static func password(_ value: String?, required: Bool) -> Validator<String> {
        .init(
            key: "password",
            value: value,
            required: required,
            invocation: .all,
            rules: [
                .trimmedNonempty(message: "Password is required."),
            ]
        )
    }
}

extension AdminAuthCredentialFormInput {
    func validate(requiredPassword: Bool) async throws(ValidationError) {
        try await GroupValidator {
            AdminAuthCredentialFormValidation.email(email)
            AdminAuthCredentialFormValidation.password(
                requiredPassword || !password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                    ? password
                    : nil,
                required: requiredPassword
            )
        }.validate()
    }
}
