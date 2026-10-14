import FeatherAdmin
import HTML
import WebComponents

protocol AdminViewSystemVariablePresenter: Sendable {

    func renderDetailsPage(
        variable: SystemVariableDetailsModel,
        permissions: AdminListActions
    ) async throws -> HTMLResponse

    func renderErrorPage(
        error: AdminViewSystemVariableError
    ) async throws -> HTMLResponse

}
