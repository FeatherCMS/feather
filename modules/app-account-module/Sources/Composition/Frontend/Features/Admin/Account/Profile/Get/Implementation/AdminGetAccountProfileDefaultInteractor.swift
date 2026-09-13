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

struct AdminGetAccountProfileDefaultInteractor: AdminGetAccountProfileInteractor
{
    let accountProfileRepository: any AdminGetAccountProfileRepository

    func getAccountProfile() async throws -> AdminAccountProfileModel {
        try await accountProfileRepository.get()
    }

    func getProfile(
        account: AccountModel,
        accountProfile: AdminAccountProfileModel
    ) async throws -> AdminGetAccountProfileModel {
        .init(account: account, accountProfile: accountProfile)
    }
}
