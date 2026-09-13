import FeatherAdmin
import Foundation
import HTML
import WebComponents

protocol AdminViewSystemVariablePresenter: Sendable {

    func renderDetailsPage(
        variable: SystemVariableDetailsModel,
        permissions: NewAdminListActions
    ) async throws -> HTMLResponse

    func renderErrorPage(
        error: AdminViewSystemVariableError
    ) async throws -> HTMLResponse

}
