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

struct AdminAddAuthEmailDefaultInteractor: AdminAddAuthEmailInteractor {
    let repository: any AdminAddAuthEmailRepository

    func listIdentities() async throws -> [AuthCredentialIdentityOption] {
        try await repository.listIdentities()
    }

    func execute(
        entity: AdminAddAuthEmailModel
    ) async throws {
        try await repository.create(payload: entity.payload)
    }
}
