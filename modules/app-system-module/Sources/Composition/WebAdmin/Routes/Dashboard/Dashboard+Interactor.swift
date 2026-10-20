import FeatherAdmin
import SystemModule

extension Dashboard {
    enum Interactor {}
}

extension Dashboard.Interactor {
    protocol Interface: Sendable {
        func getHome(
            context: Dashboard.Event.Context
        ) async throws -> Dashboard.Model
    }
}
