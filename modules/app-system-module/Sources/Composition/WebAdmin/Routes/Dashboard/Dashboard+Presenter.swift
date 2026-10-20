import FeatherAdmin
import SystemModule

extension Dashboard {
    enum Presenter {}
}

extension Dashboard.Presenter {
    protocol Interface: Sendable {

        func renderPage(
            model: Dashboard.Model
        ) async throws -> HTMLResponse
    }
}
