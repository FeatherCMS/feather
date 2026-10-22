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



extension Email.Edit.Repository {
    protocol Interface: Sendable {

        func listIdentities() async throws -> [Credential.Form.IdentityOption]

        func get(
            id: String
        ) async throws -> Email.View.Detail

        func update(
            id: String,
            payload: Email.Form.Payload
        ) async throws
    }
}
