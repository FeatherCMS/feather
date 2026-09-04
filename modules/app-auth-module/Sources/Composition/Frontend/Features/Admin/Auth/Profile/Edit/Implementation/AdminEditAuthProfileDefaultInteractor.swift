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

struct AdminEditAuthProfileDefaultInteractor:
    AdminEditAuthProfileInteractor
{
    let accountProfileRepository: any AdminAuthAccountProfileRepository

    func loadProfile(
        account: AccountModel
    ) async throws -> AdminEditAuthProfileModel {
        let accountProfile = try await accountProfileRepository.get()
        return .init(
            id: account.user.id,
            firstName: accountProfile.firstName,
            lastName: accountProfile.lastName,
            profileImageAssetId: accountProfile.profileImageAssetId,
            profileImageAsset: accountProfile.profileImageAsset
        )
    }

    func execute(
        entity: AdminEditAuthProfileModel
    ) async throws {
        try await accountProfileRepository.update(
            profile: entity.accountProfile
        )
    }
}
