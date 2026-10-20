import FeatherAdmin
import SystemModule

extension WebAdmin.System.Dashboard {
    enum Interactor {}
}

extension WebAdmin.System.Dashboard.Interactor {
    protocol Interface: Sendable {
        func getHome(
            context: AdminDashboardEventContext
        ) async throws -> WebAdmin.System.Dashboard.Model
    }
}
