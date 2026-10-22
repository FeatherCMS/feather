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

extension MagicLink.Add.Presenter {
    protocol Interface: Sendable {

        func renderPage(
            form: MagicLink.Add.Form.State,
            permissions: Set<String>
        ) async throws -> HTMLResponse
        func renderForbiddenPage() async throws -> HTMLResponse

        func formState(
            credentialId: String,
            emails: [AuthAdminAPI.Components.Schemas.AuthEmailSchemasDetail],
            isPersistent: Bool
        ) -> MagicLink.Add.Form.State

        func format(
            error: OpenAPIRepositoryError
        ) -> String
    }
}
