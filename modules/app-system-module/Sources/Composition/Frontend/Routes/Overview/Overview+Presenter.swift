import FeatherAdmin
import Hummingbird
import SystemModule

extension WebAdmin.System.Overview {
    enum Presenter {}
}

extension WebAdmin.System.Overview.Presenter {
    protocol Interface: Sendable {

        func renderOverview(
            model: WebAdmin.System.Overview.Model,
            permissions: Set<String>
        ) async throws -> HTMLResponse
    }
}
