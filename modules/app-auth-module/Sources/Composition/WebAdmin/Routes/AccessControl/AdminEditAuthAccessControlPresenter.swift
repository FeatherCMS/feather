import AuthAdminAPI
import CSS
import FeatherValidation
import FeatherValidationFoundation
import FeatherWebAdmin
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
