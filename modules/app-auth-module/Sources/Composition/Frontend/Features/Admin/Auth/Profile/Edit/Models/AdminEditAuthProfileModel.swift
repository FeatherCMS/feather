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

struct AdminEditAuthProfileModel: Sendable {
    let id: String
    let email: String
    let password: String?

    var payload: AdminEditAuthProfileFormPayloadModel {
        .init(email: email, password: password)
    }
}
