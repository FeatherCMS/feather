import FeatherAdmin
import SystemModule

extension WebAdmin.System.Dashboard {
    enum Presenter {}
}

extension WebAdmin.System.Dashboard.Presenter {
    protocol Interface: Sendable {

        func renderPage(
            model: WebAdmin.System.Dashboard.Model
        ) async throws -> HTMLResponse
    }
}
