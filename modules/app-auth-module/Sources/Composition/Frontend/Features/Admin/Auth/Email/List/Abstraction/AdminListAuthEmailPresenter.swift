import AuthAdminAPI
import AuthAppAPI
import CSS
import FeatherWebAdmin
import FeatherValidation
import FeatherValidationFoundation
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

protocol AdminListAuthEmailPresenter: Sendable {

    func renderPage(
        state: AuthEmailTable.State
    ) async throws -> HTMLResponse

    func renderError(
        error: OpenAPIRepositoryError
    ) async throws -> HTMLResponse
    func renderInvalidNoncePage() async throws -> HTMLResponse
}
