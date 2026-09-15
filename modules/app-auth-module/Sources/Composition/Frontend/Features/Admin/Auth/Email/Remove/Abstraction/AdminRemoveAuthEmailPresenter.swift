import AuthAdminAPI
import AuthAppAPI
import CSS
import FeatherAdmin
import FeatherValidation
import FeatherValidationFoundation
import Foundation
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

protocol AdminRemoveAuthEmailPresenter: Sendable {

    func renderPage(
        item: NewAdminRemoveItemContext,
        identityId: String,
    ) async throws -> HTMLResponse
    func renderInvalidNoncePage() async throws -> HTMLResponse

    func renderError(
        item: NewAdminRemoveItemContext,
        error: OpenAPIRepositoryError
    ) async throws -> HTMLResponse
}
