import FeatherAdmin
import WebComponents

protocol AdminGetSystemJobPresenter: Sendable {
    func renderDetailsPage(
        job: SystemJobDetailsModel
    ) async throws -> HTMLResponse

    func renderErrorPage(
        info: String,
        message: String
    ) async throws -> HTMLResponse
}
