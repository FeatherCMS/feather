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
    let firstName: String?
    let lastName: String?
    let imageURL: String?

    var accountProfile: AdminAuthAccountProfileModel {
        .init(firstName: firstName, lastName: lastName, imageURL: imageURL)
    }
}
