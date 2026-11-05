import AuthAdminAPI
import AuthModule
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

extension Email.Edit.Interactor {
    struct Default: Interface {
        let repository: any Email.Edit.Repository.Interface

        func listIdentities() async throws -> [Credential.Form.IdentityOption] {
            try await repository.listIdentities()
        }

        func get(
            id: String
        ) async throws -> Email.View.Detail {
            try await repository.get(id: id)
        }

        func execute(
            entity: Email.Edit.Model
        ) async throws {
            try await repository.update(
                id: entity.id,
                payload: entity.payload
            )
        }
    }
}
