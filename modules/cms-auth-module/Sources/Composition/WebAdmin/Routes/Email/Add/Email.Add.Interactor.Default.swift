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

extension Email.Add.Interactor {
    struct Default: Interface {
        let repository: any Email.Add.Repository.Interface

        func listIdentities() async throws -> [Credential.Form.IdentityOption] {
            try await repository.listIdentities()
        }

        func execute(
            entity: Email.Add.Model
        ) async throws {
            try await repository.create(payload: entity.payload)
        }
    }
}
