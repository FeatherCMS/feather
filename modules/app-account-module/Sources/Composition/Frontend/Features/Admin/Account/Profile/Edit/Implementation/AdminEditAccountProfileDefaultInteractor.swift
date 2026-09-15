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

struct AdminEditAccountProfileDefaultInteractor:
    AdminEditAccountProfileInteractor
{
    let accountProfileRepository: any AdminEditAccountProfileRepository

    func loadProfile(
        account: AccountModel
    ) async throws -> AdminEditAccountProfileModel {
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
        entity: AdminEditAccountProfileModel
    ) async throws {
        try await accountProfileRepository.update(
            profile: entity.accountProfile
        )
    }
}
