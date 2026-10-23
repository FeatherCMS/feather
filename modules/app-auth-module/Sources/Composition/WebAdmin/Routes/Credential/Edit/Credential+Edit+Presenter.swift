import AuthAdminAPI
import AuthModule
import CSS
import FeatherValidation
import FeatherValidationFoundation
import FeatherWebAdmin
import FeatherWebShared
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
    enum Presenter {}
}

extension Credential.Edit.Presenter {
    protocol Interface: Sendable {
        func renderPage(
            id: String,
            form: Credential.Form.Component.State,
            permissions: Set<String>
        ) async throws -> HTMLResponse
        func renderError(
            id: String,
            error: OpenAPIRepositoryError,
            permissions: Set<String>
        ) async throws -> HTMLResponse
        func formState(
            userId: String,
            emails: [AuthAdminAPI.Components.Schemas.AuthEmailSchemasDetail],
            email: String,
            password: String
        ) -> Credential.Form.Component.State
        func format(error: OpenAPIRepositoryError) -> String
    }
}
