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

struct AdminGetAuthMagicLinkDefaultInteractor: AdminGetAuthMagicLinkInteractor {
    let repository: any AdminGetAuthMagicLinkRepository

    func execute(
        entity: AdminGetAuthMagicLinkModel
    ) async throws -> AuthMagicLinkDetailsModel {
        try await repository.get(id: entity.id)
    }
}
