import AuthAdminAPI
import AuthAppAPI
import CSS
import FeatherWebAdmin
import FeatherValidation
import FeatherValidationFoundation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import SystemAdminAPI
import SystemWebAdmin
import UserAdminAPI
import UserWebAdmin
import WebBuilders
import WebComponents

struct AdminViewAuthMagicLinkDefaultInteractor: AdminViewAuthMagicLinkInteractor
{
    let repository: any AdminViewAuthMagicLinkRepository

    func execute(
        entity: AdminViewAuthMagicLinkModel
    ) async throws -> AuthMagicLinkDetailsModel {
        try await repository.get(id: entity.id)
    }
}
