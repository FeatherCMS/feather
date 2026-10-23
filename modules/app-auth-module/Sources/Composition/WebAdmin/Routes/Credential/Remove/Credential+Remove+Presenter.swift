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

extension Credential.Remove {
    enum Presenter {}
}

extension Credential.Remove.Presenter {
    protocol Interface: Sendable {
        func renderPage(
            item: AdminRemoveItemContext,
            model: Credential.Edit.Model
        )
            async throws -> HTMLResponse
        func renderInvalidNoncePage() async throws -> HTMLResponse
        func renderError(
            item: AdminRemoveItemContext,
            error: OpenAPIRepositoryError
        ) async throws -> HTMLResponse
    }
}
