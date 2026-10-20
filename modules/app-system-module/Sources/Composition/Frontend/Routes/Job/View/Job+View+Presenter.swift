import FeatherAdmin
import SystemModule

extension WebAdmin.System.Job.View {
    enum Presenter {}
}

extension WebAdmin.System.Job.View.Presenter {
    protocol Interface: Sendable {
        func renderDetailsPage(
            job: SystemJobDetailsModel
        ) async throws -> HTMLResponse

        func renderErrorPage(
            error: WebAdmin.System.Job.View.Error
        ) async throws -> HTMLResponse
    }
}
