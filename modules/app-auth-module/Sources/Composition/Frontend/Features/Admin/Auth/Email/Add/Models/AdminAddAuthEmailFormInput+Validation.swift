import AuthAdminAPI
import AuthAppAPI
import CSS
import FeatherWebAdmin
public import FeatherValidation
import FeatherValidationFoundation
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
