import AuthAdminAPI
import AuthAppAPI
import CSS
import FeatherAdmin
import FeatherValidation
import FeatherValidationFoundation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import SystemAdminAPI
import SystemFrontend
import UserAdminAPI
import UserAppAPI
import UserFrontend
import WebBuilders
import WebComponents

protocol AdminRemoveAuthCredentialPresenter: Sendable {
    func renderPage(
        item: NewAdminRemoveItemContext,
        model: AuthCredentialDetailsModel
    )
        async throws -> HTMLResponse
    func renderInvalidNoncePage() async throws -> HTMLResponse
    func renderError(
        item: NewAdminRemoveItemContext,
        error: OpenAPIRepositoryError
    ) async throws -> HTMLResponse
}
