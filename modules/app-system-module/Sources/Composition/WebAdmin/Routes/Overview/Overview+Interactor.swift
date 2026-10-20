import FeatherWebAdmin
import Hummingbird
import SystemModule

extension Overview {
    enum Interactor {}
}

extension Overview.Interactor {
    protocol Interface: Sendable {

        func getOverview() async throws
            -> Overview.Model
    }
}
