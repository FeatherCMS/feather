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

extension Credential.Add.Interactor {
    struct Default: Interface {
        let repository: any Credential.Add.Repository.Interface

        func listEmails() async throws -> [Credential.Form.IdentityOption] {
            try await repository.listEmails()
        }

        func execute(payload: Credential.Form.Payload) async throws {
            try await repository.create(payload: payload)
        }
    }
}
