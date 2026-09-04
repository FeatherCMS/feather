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

enum AdminAddAuthEmailFormFieldValidator {

    static func identityId(
        _ value: String?,
        required: Bool
    ) -> Validator<String> {
        .init(
            key: "identity_id",
            value: value,
            required: required,
            invocation: .all,
            rules: [
                .trimmedNonempty(message: "Identity ID is required.")
            ]
        )
    }
}

extension AdminAddAuthEmailFormInput {

    private var validator: GroupValidator {
        GroupValidator {
            AdminAddAuthEmailFormFieldValidator.identityId(
                identityId,
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
