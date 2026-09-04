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
import WebComponents
import WebBuilders

protocol AdminGetAuthProfileInteractor: Sendable {
    func getAccountProfile() async throws -> AdminAuthAccountProfileModel

    func getProfile(
        account: AccountModel,
        accountProfile: AdminAuthAccountProfileModel
    ) async throws -> AdminGetAuthProfileModel
}
