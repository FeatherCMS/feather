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

struct AdminGetAuthProfileDefaultInteractor: AdminGetAuthProfileInteractor {
    let accountProfileRepository: any AdminAuthAccountProfileRepository

    func getAccountProfile() async throws -> AdminAuthAccountProfileModel {
        try await accountProfileRepository.get()
    }

    func getProfile(
        account: AccountModel,
        accountProfile: AdminAuthAccountProfileModel
    ) async throws -> AdminGetAuthProfileModel {
        .init(account: account, accountProfile: accountProfile)
    }
}
