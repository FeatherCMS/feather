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

extension Credential.Add {
    enum Presenter {}
}

extension Credential.Add.Presenter {
    protocol Interface: Sendable {
        func renderPage(
            form: Credential.Form.Component.State,
            permissions: Set<String>
        ) async throws -> HTMLResponse
        func renderForbiddenPage() async throws -> HTMLResponse
        func format(error: OpenAPIRepositoryError) -> String
        func formState(
            userId: String,
            email: String,
            password: String
        ) -> Credential.Form.Component.State
    }
}
