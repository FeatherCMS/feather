import FeatherAdmin
import SystemModule

extension Job.View {
    enum Presenter {}
}

extension Job.View.Presenter {
    protocol Interface: Sendable {
        func renderDetailsPage(
            job: SystemJobDetailsModel
        ) async throws -> HTMLResponse

        func renderErrorPage(
            error: Job.View.Error
        ) async throws -> HTMLResponse
    }
}
