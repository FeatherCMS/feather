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

extension Credential.List {
    enum Presenter {}
}

extension Credential.List.Presenter {
    protocol Interface: Sendable {
        func renderPage(
            state: Credential.List.Component.State
        ) async throws -> HTMLResponse

        func renderError(
            error: OpenAPIRepositoryError
        ) async throws -> HTMLResponse
    }
}
