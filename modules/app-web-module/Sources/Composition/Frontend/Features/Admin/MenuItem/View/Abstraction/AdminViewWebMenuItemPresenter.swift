import FeatherAdmin
import Foundation
import HTML
import OpenAPIRuntime

protocol AdminViewWebMenuItemPresenter: Sendable {

    func renderDetailsPage(
        rule: WebMenuItemDetailsModel,
        permissions: Set<String>
    ) async throws -> HTMLResponse

    func renderErrorPage(
        menuId: String,
        info: String,
        message: String,
        permissions: Set<String>
    ) async throws -> HTMLResponse

}
