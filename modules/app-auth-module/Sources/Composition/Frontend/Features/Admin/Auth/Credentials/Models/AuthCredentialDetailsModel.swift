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

struct AuthCredentialDetailsModel: Sendable {
    let id: String
    let userId: String
    let email: String
}

struct AuthCredentialIdentityOption: Sendable, Equatable {
    let id: String
    let label: String
}
