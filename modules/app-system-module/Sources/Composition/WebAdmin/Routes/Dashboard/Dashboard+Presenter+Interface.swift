import FeatherWebAdmin
import SystemModule

extension Dashboard.Presenter {
    protocol Interface: Sendable {

        func renderPage(
            model: Dashboard.Model
        ) async throws -> HTMLResponse
    }
}
