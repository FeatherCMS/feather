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

extension Credential.Edit {
    enum Interactor {}
}

extension Credential.Edit.Interactor {
    protocol Interface: Sendable {
        func get(id: String) async throws -> Credential.Edit.Model
        func listEmails() async throws -> [Email.Option]
        func execute(id: String, payload: Credential.Form.Payload)
            async throws
    }
}
