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

extension Email.Edit.Form {
    enum Validator {

        static func identityId(
            _ value: String?,
            required: Bool
        ) -> FeatherValidation.Validator<String> {
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
}

extension Email.Edit.Form.Input {

    private var validator: GroupValidator {
        GroupValidator {
            Email.Edit.Form.Validator.identityId(
                identityId,
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
