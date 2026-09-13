import FeatherAdmin
import WebComponents

protocol AdminGetSystemJobPresenter: Sendable {
    func renderDetailsPage(
        job: SystemJobDetailsModel
    ) async throws -> HTMLResponse

    func renderErrorPage(
        error: AdminGetSystemJobError
    ) async throws -> HTMLResponse
}
