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

extension MagicLink.List {
    enum Presenter {}
}

extension MagicLink.List.Presenter {
    protocol Interface: Sendable {

        func renderPage(
            state: MagicLink.List.ListTable.State
        ) async throws -> HTMLResponse

        func renderError(
            error: OpenAPIRepositoryError
        ) async throws -> HTMLResponse
        func renderInvalidNoncePage() async throws -> HTMLResponse
    }
}
