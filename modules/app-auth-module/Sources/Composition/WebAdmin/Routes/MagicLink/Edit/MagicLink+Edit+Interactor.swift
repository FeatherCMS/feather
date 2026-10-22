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
    protocol Interface: Sendable {

        func listEmails() async throws -> [AuthAdminAPI.Components.Schemas
            .AuthEmailSchemasDetail]

        func get(
            id: String
        ) async throws -> MagicLink.View.Detail

        func execute(
            entity: MagicLink.Edit.Model
        ) async throws
    }
}
