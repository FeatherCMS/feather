import AuthAdminAPI
import CSS
import FeatherValidation
import FeatherValidationFoundation
import FeatherWebAdmin
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

struct AdminViewAuthEmailDefaultInteractor: AdminViewAuthEmailInteractor {
    let repository: any AdminViewAuthEmailRepository

    func execute(
        entity: AdminViewAuthEmailModel
    ) async throws -> AuthEmailDetailsModel {
        try await repository.get(id: entity.id)
    }
}
