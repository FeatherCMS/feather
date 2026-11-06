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

extension Credential.Remove.Interactor {
    struct Default: Interface {
        let repository: any Credential.Remove.Repository.Interface

        func get(id: String) async throws -> Credential.Edit.Model {
            try await repository.get(id: id)
        }

        func delete(id: String) async throws {
            try await repository.delete(id: id)
        }
    }
}
