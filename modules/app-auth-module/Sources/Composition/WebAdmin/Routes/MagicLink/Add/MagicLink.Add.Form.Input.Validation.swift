import AuthAdminAPI
import AuthModule
import CSS
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

extension MagicLink.Add.Form.Input {
    enum Validator {
        static func credentialId(
            _ value: String?,
            required: Bool
        ) -> FeatherValidation.Validator<String> {
            .init(
                key: "credential_id",
                value: value,
                required: required,
                invocation: .all,
                rules: [
                    .trimmedNonempty(message: "Credential ID is required.")
                ]
            )
        }
    }
}

extension MagicLink.Add.Form.Input {

    private var validator: GroupValidator {
        GroupValidator {
            Validator.credentialId(
                credentialId,
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
