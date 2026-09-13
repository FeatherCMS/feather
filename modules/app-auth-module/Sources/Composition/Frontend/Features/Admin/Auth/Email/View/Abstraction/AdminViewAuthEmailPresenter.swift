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

protocol AdminViewAuthEmailPresenter: Sendable {

    func breadcrumb(
        id: String
    ) -> [NewAdminBreadcrumb.Link]

    func renderPage(
        link: AuthEmailDetailsModel,
        permissions: Set<String>
    ) async throws -> HTMLResponse

    func renderError(
        id: String,
        error: OpenAPIRepositoryError,
        permissions: Set<String>
    ) async throws -> HTMLResponse
}
