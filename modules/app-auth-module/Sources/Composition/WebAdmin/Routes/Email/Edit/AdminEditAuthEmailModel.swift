import AuthAdminAPI
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

struct AdminEditAuthEmailModel: Sendable {
    let id: String
    let identityId: String
    let email: String

    var payload: AuthEmailFormPayloadModel {
        .init(identityId: identityId, email: email)
    }
}
