import FeatherAdmin
import Foundation
import HTML
import WebComponents

protocol AdminGetSystemVariablePresenter: Sendable {

    func renderDetailsPage(
        variable: SystemVariableDetailsModel,
        permissions: NewAdminListActions
    ) async throws -> HTMLResponse

    func renderErrorPage(
        info: String,
        message: String
    ) async throws -> HTMLResponse

}
