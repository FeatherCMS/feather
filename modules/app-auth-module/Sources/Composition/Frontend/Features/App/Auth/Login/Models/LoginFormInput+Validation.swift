import AuthAdminAPI
import AuthAppAPI
import CSS
import FeatherAdmin
import FeatherValidation
import FeatherValidationFoundation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import SystemAdminAPI
import SystemFrontend
import UserAdminAPI
import UserAppAPI
import UserFrontend
import WebComponents
import WebBuilders

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

    public func validationFailures() async -> [Failure] {
        await validator.failures()
    }
}
