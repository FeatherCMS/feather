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

struct AdminGetAuthProfileModel: Sendable {
    let id: String
    let email: String
    let roles: [String]
    let permissions: [String]

    init(account: AccountModel) {
        self.id = account.user.id
        self.email = account.user.email
        self.roles = account.roles
        self.permissions = account.permissions
    }
}
