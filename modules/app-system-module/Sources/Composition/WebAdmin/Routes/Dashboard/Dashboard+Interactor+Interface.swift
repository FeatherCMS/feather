import FeatherWebAdmin
import SystemModule

extension Dashboard.Interactor {
    protocol Interface: Sendable {
        func getHome(
            context: Dashboard.Event.Context
        ) async throws -> Dashboard.Model
    }
}
