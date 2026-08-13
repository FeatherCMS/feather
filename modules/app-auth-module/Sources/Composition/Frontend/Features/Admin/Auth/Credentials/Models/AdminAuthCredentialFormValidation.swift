import AuthAdminAPI
import AuthAppAPI
import CSS
import FeatherAdmin
import FeatherValidation
import FeatherValidationFoundation
import Foundation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import SystemAdminAPI
import SystemFrontend
import UserAdminAPI
import UserAppAPI
import UserFrontend
import WebStandards

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

    static func password(_ value: String?, required: Bool) -> Validator<String>
    {
        .init(
            key: "password",
            value: value,
            required: required,
            invocation: .all,
            rules: [
                .trimmedNonempty(message: "Password is required.")
            ]
        )
    }
}

extension AdminAuthCredentialFormInput {
    func validate(requiredPassword: Bool) async throws(ValidationError) {
        try await GroupValidator {
            AdminAuthCredentialFormValidation.email(email)
            AdminAuthCredentialFormValidation.password(
                requiredPassword
                    || !password.trimmingCharacters(in: .whitespacesAndNewlines)
                        .isEmpty
                    ? password
                    : nil,
                required: requiredPassword
            )
        }
        .validate()
    }
}
