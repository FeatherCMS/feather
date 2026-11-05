import FeatherWebAdmin
import Hummingbird

extension Overview {
    enum Interactor {}
}

extension Overview.Interactor {
    protocol Interface: Sendable {

        func getOverview() async throws -> Overview.Model
    }
}
