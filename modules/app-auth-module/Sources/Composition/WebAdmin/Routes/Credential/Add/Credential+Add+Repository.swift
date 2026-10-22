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



extension Credential.Add.Repository {
    protocol Interface: Sendable {
        func listEmails() async throws -> [Credential.Form.IdentityOption]
        func create(payload: Credential.Form.Payload) async throws
    }
}
