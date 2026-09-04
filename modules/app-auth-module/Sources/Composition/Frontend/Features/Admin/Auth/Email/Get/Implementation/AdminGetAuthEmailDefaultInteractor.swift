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

struct AdminGetAuthEmailDefaultInteractor: AdminGetAuthEmailInteractor {
    let repository: any AdminGetAuthEmailRepository

    func execute(
        entity: AdminGetAuthEmailModel
    ) async throws -> AuthEmailDetailsModel {
        try await repository.get(id: entity.id)
    }
}
