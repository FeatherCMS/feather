import AuthAdminAPI
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

protocol AdminListAuthEmailPresenter: Sendable {

    func renderPage(
        state: AuthEmailTable.State
    ) async throws -> HTMLResponse

    func renderError(
        error: OpenAPIRepositoryError
    ) async throws -> HTMLResponse
    func renderInvalidNoncePage() async throws -> HTMLResponse
}
