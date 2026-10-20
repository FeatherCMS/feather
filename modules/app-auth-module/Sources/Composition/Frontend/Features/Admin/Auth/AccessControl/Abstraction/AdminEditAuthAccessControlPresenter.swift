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

protocol AdminEditAuthAccessControlPresenter: Sendable {

    func deniedPage(
        permissions: Set<String>,
        message: String
    ) async throws -> HTMLResponse

    func renderPage(
        state: AdminEditAuthAccessControlState,
        permissions: Set<String>,
        search: String
    ) async throws -> HTMLResponse
}
