import AuthAdminAPI
import AuthAppAPI
import CSS
import FeatherAdmin
import FeatherValidation
import FeatherValidationFoundation
import Foundation
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

struct AppLoginAuthModel: Sendable {
    let email: String
    let password: String
    let isPersistent: Bool

    var command: LoginCommandModel {
        .init(email: email, password: password, isPersistent: isPersistent)
    }
}
