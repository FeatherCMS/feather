import AuthAdminAPI
import AuthAppAPI
import CSS
import FeatherAdmin
import FeatherValidation
import FeatherValidationFoundation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import SystemAdminAPI
import SystemModuleWebAdmin
import UserAdminAPI
import UserAppAPI
import UserFrontend
import WebBuilders
import WebComponents

struct AdminRemoveAuthEmailDefaultInteractor:
    AdminRemoveAuthEmailInteractor
{
    let repository: any AdminRemoveAuthEmailRepository

    func get(
        id: String
    ) async throws -> AuthEmailDetailsModel {
        try await repository.get(id: id)
    }

    func execute(
        entity: AdminRemoveAuthEmailModel
    ) async throws {
        try await repository.delete(id: entity.id)
    }

    func remove(
        ids: [String]
    ) async throws {
        for id in ids {
            try await repository.delete(id: id)
        }
    }
}
