import AuthAdminAPI
import FeatherWebShared
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

protocol AdminRemoveAuthEmailPresenter: Sendable {

    func renderPage(
        item: AdminRemoveItemContext,
        identityId: String,
    ) async throws -> HTMLResponse
    func renderInvalidNoncePage() async throws -> HTMLResponse

    func renderError(
        item: AdminRemoveItemContext,
        error: OpenAPIRepositoryError
    ) async throws -> HTMLResponse
}
