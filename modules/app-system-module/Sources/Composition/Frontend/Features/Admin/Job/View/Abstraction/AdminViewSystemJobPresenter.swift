import FeatherAdmin
import WebComponents

protocol AdminViewSystemJobPresenter: Sendable {
    func renderDetailsPage(
        job: SystemJobDetailsModel
    ) async throws -> HTMLResponse

    func renderErrorPage(
        error: AdminViewSystemJobError
    ) async throws -> HTMLResponse
}
