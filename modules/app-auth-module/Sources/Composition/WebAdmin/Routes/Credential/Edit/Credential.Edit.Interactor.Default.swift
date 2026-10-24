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

extension Credential.Edit.Interactor {
    struct Default: Interface {
        let repository: any Credential.Edit.Repository.Interface

        func listEmails() async throws -> [AuthAdminAPI.Components.Schemas
            .AuthEmailSchemasDetail]
        {
            try await repository.listEmails()
        }

        func get(id: String) async throws -> Credential.Edit.Model {
            try await repository.get(id: id)
        }

        func execute(id: String, payload: Credential.Form.Payload)
            async throws
        {
            try await repository.update(id: id, payload: payload)
        }
    }
}
