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

protocol AdminEditAccountProfilePresenter: Sendable {

    func renderPage(
        state: AccountProfileEdit.State,
        permissions: Set<String>
    ) async throws -> HTMLResponse

    func renderDeniedPage(
        permissions: Set<String>
    ) async throws -> HTMLResponse
}
