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

enum AdminEditAuthMagicLinkFormFieldValidator {

    static func credentialId(
        _ value: String?,
        required: Bool
    ) -> Validator<String> {
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

extension AdminEditAuthMagicLinkFormInput {

    private var validator: GroupValidator {
        GroupValidator {
            AdminEditAuthMagicLinkFormFieldValidator.credentialId(
                credentialId,
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
