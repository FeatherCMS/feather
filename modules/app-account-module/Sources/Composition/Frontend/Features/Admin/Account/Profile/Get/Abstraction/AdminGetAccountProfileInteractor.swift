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
import WebBuilders
import WebComponents

protocol AdminGetAccountProfileInteractor: Sendable {
    func getAccountProfile() async throws -> AdminAccountProfileModel

    func getProfile(
        account: AccountModel,
        accountProfile: AdminAccountProfileModel
    ) async throws -> AdminGetAccountProfileModel
}
