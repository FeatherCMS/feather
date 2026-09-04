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

struct AdminRemoveAuthMagicLinkDefaultInteractor:
    AdminRemoveAuthMagicLinkInteractor
{
    let repository: any AdminRemoveAuthMagicLinkRepository

    func get(
        id: String
    ) async throws -> AuthMagicLinkDetailsModel {
        try await repository.get(id: id)
    }

    func execute(
        entity: AdminRemoveAuthMagicLinkModel
    ) async throws {
        try await repository.delete(id: entity.id)
    }
}
