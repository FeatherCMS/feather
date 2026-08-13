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

    func loadProfile(
        account: AccountModel
    ) async throws -> AdminEditAuthProfileModel {
        .init(
            id: account.user.id,
            email: account.user.email,
            password: nil
        )
    }

    func execute(
        entity: AdminEditAuthProfileModel
    ) async throws {
        try await repository.update(
            id: entity.id,
            payload: entity.payload
        )
    }
}
