import FeatherAdmin
import Hummingbird
import SystemModule

extension WebAdmin.System.Overview {
    enum Interactor {}
}

extension WebAdmin.System.Overview.Interactor {
    protocol Interface: Sendable {

        func getOverview() async throws -> WebAdmin.System.Overview.Model
    }
}
