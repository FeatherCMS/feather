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

extension Email.Add {
    enum Repository {}
}

extension Email.Add.Repository {
    protocol Interface: Sendable {

        func listIdentities() async throws -> [Credential.Form.IdentityOption]

        func create(
            payload: Email.Form.Payload
        ) async throws
    }
}
