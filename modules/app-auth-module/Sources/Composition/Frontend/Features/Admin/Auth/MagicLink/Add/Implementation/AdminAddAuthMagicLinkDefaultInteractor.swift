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

struct AdminAddAuthMagicLinkDefaultInteractor: AdminAddAuthMagicLinkInteractor {
    let repository: any AdminAddAuthMagicLinkRepository

    func listEmails() async throws
        -> [AuthAdminAPI.Components.Schemas.AuthEmailDetailSchema]
    {
        try await repository.listEmails()
    }

    func execute(
        entity: AdminAddAuthMagicLinkModel
    ) async throws {
        try await repository.create(payload: entity.payload)
    }
}
