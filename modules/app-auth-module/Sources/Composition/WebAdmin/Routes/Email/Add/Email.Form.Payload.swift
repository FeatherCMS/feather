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

extension Email.Form {
    struct Payload: Sendable {
        let identityId: String
        let email: String

        init(
            identityId: String,
            email: String = ""
        ) {
            self.identityId = identityId
            self.email = email
        }
    }
}
