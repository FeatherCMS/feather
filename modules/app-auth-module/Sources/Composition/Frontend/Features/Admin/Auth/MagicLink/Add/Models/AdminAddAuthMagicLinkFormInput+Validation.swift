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
import WebStandards

enum AdminAddAuthMagicLinkFormFieldValidator {

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

extension AdminAddAuthMagicLinkFormInput {

    private var validator: GroupValidator {
        GroupValidator {
            AdminAddAuthMagicLinkFormFieldValidator.credentialId(
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
