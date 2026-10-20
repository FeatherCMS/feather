import AuthAdminAPI
import AuthAppAPI
import CSS
import FeatherWebAdmin
import FeatherValidation
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

struct AdminAddAuthEmailModel: Sendable {
    let identityId: String
    let email: String

    init(
        identityId: String,
        email: String = ""
    ) {
        self.identityId = identityId
        self.email = email
    }

    var payload: AuthEmailFormPayloadModel {
        .init(
            identityId: identityId,
            email: email
        )
    }
}
