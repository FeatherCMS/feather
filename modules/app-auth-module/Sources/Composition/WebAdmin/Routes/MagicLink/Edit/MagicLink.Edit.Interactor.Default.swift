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

extension MagicLink.Edit.Interactor {
    struct Default: Interface {
        let repository: any MagicLink.Edit.Repository.Interface

        func listEmails() async throws -> [AuthAdminAPI.Components.Schemas
            .AuthEmailSchemasDetail]
        {
            try await repository.listEmails()
        }

        func get(
            id: String
        ) async throws -> MagicLink.View.Detail {
            try await repository.get(id: id)
        }

        func execute(
            entity: MagicLink.Edit.Model
        ) async throws {
            try await repository.update(
                id: entity.id,
                payload: entity.payload
            )
        }
    }
}
