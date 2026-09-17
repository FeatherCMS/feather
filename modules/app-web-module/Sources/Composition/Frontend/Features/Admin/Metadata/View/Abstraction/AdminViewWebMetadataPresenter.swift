import FeatherAdmin
import Foundation
import HTML
import OpenAPIRuntime

protocol AdminViewWebMetadataPresenter: Sendable {

    func renderDetailsPage(
        rule: WebMetadataDetailsModel,
        permissions: Set<String>
    ) async throws -> HTMLResponse

    func renderErrorPage(
        info: String,
        message: String,
        permissions: Set<String>
    ) async throws -> HTMLResponse

}
