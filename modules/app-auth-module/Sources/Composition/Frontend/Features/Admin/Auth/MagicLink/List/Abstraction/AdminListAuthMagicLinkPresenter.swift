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

protocol AdminListAuthMagicLinkPresenter: Sendable {

    func renderPage(
        state: AuthMagicLinkTable.State
    ) async throws -> HTMLResponse

    func renderError(
        error: OpenAPIRepositoryError
    ) async throws -> HTMLResponse

    func renderRemovePage(
        items: [NewAdminRemoveItemContext],
        page: Int,
        search: String?,
        userID: String?
    ) async throws -> HTMLResponse
    func renderInvalidNoncePage() async throws -> HTMLResponse
}
