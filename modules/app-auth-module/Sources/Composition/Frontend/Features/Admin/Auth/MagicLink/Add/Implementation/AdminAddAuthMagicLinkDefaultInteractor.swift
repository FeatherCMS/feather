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
