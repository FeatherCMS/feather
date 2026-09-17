import FeatherAdmin
import Foundation
import HTML
import OpenAPIRuntime

protocol AdminViewWebPagePresenter: Sendable {

    func renderDetailsPage(
        rule: WebPageDetailsModel,
        permissions: Set<String>
    ) async throws -> HTMLResponse

    func renderErrorPage(
        info: String,
        message: String,
        permissions: Set<String>
    ) async throws -> HTMLResponse

}
