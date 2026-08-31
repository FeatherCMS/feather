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

struct AdminEditAuthProfileDefaultInteractor:
    AdminEditAuthProfileInteractor
{
    let repository: any AdminEditAuthProfileRepository
    let accountProfileRepository: any AdminAuthAccountProfileRepository

    func loadProfile(
        account: AccountModel
    ) async throws -> AdminEditAuthProfileModel {
        let accountProfile = try await accountProfileRepository.get()
        return .init(
            id: account.user.id,
            email: account.user.email,
            password: nil,
            firstName: accountProfile.firstName,
            lastName: accountProfile.lastName,
            imageURL: accountProfile.imageURL
        )
    }

    func execute(
        entity: AdminEditAuthProfileModel
    ) async throws {
        try await repository.update(
            id: entity.id,
            payload: entity.payload
        )
        try await accountProfileRepository.update(
            profile: entity.accountProfile
        )
    }
}
