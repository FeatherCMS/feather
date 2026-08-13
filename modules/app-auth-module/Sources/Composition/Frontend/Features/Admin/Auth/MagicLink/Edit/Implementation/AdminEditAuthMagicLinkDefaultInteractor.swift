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

struct AdminEditAuthMagicLinkDefaultInteractor: AdminEditAuthMagicLinkInteractor
{
    let repository: any AdminEditAuthMagicLinkRepository

    func get(
        id: String
    ) async throws -> AuthMagicLinkDetailsModel {
        try await repository.get(id: id)
    }

    func execute(
        entity: AdminEditAuthMagicLinkModel
    ) async throws {
        try await repository.update(
            id: entity.id,
            payload: entity.payload
        )
    }
}
