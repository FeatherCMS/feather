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

extension Email.Add.Presenter {
    protocol Interface: Sendable {

        func renderPage(
            form: Email.Form.Component.State,
            permissions: Set<String>
        ) async throws -> HTMLResponse
        func renderForbiddenPage() async throws -> HTMLResponse

        func formState(
            identityId: String,
            identities: [Credential.Form.IdentityOption]
        ) -> Email.Form.Component.State

        func format(
            error: OpenAPIRepositoryError
        ) -> String
    }
}
