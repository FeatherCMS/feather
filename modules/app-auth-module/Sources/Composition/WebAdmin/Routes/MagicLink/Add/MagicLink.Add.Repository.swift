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

extension MagicLink.Add {
    enum Repository {}
}

extension MagicLink.Add.Repository {
    protocol Interface: Sendable {

        func listEmails() async throws
            -> [AuthAdminAPI.Components.Schemas.AuthEmailSchemasDetail]

        func create(
            payload: MagicLink.Add.Payload
        ) async throws
    }
}
