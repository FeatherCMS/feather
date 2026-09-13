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

struct AdminViewAccountProfileDefaultInteractor: AdminViewAccountProfileInteractor
{
    let accountProfileRepository: any AdminViewAccountProfileRepository

    func getAccountProfile() async throws -> AdminAccountProfileModel {
        try await accountProfileRepository.get()
    }

    func getProfile(
        account: AccountModel,
        accountProfile: AdminAccountProfileModel
    ) async throws -> AdminViewAccountProfileModel {
        .init(account: account, accountProfile: accountProfile)
    }
}
