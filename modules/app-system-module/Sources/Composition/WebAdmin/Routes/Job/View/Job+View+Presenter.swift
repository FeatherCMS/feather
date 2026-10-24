import FeatherWebAdmin
import SystemModule

extension Job.View {
    enum Presenter {}
}

extension Job.View.Presenter {
    protocol Interface: Sendable {
        func renderDetailsPage(
            job: Job.View.Result
        ) async throws -> HTMLResponse

        func renderErrorPage(
            error: Job.View.Error
        ) async throws -> HTMLResponse
    }
}
