import AuthAdminAPI
import AuthModule
import CSS
import FeatherModuleKit
import FeatherValidation
import FeatherValidationFoundation
import FeatherWebAdmin
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import SystemAdminAPI
import SystemWebAdmin
import UserAdminAPI
import UserWebAdmin
import WebBuilders
import WebComponents

extension Credential.Form {
    enum Validator {
        static func userId(_ value: String?)
            -> FeatherValidation.Validator<String>
        {
            .init(
                key: "userId",
                value: value,
                required: true,
                invocation: .all,
                rules: [.trimmedNonempty(message: "User identity is required.")]
            )
        }
        static func email(_ value: String?)
            -> FeatherValidation.Validator<String>
        {
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
                    .trimmedNonempty(message: "Password is required.")
                ]
            )
        }
    }
}

extension Credential.Form.Input {
    func validate(
        requiredPassword: Bool,
        validateUserId: Bool = true
    ) async throws(ValidationError) {
        try await GroupValidator {
            if validateUserId {
                Credential.Form.Validator.userId(userId)
            }
            Credential.Form.Validator.email(email)
            Credential.Form.Validator.password(
                requiredPassword
                    || !password.whitespaceTrimmed
                        .isEmpty
                    ? password
                    : nil,
                required: requiredPassword
            )
        }
        .validate()
    }
}
