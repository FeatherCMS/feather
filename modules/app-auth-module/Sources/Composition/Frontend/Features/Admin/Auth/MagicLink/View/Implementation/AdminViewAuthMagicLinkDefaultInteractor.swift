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
import WebBuilders
import WebComponents

struct AdminViewAuthMagicLinkDefaultInteractor: AdminViewAuthMagicLinkInteractor {
    let repository: any AdminViewAuthMagicLinkRepository

    func execute(
        entity: AdminViewAuthMagicLinkModel
    ) async throws -> AuthMagicLinkDetailsModel {
        try await repository.get(id: entity.id)
    }
}
