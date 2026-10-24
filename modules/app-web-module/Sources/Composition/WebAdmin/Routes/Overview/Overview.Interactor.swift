import FeatherWebAdmin

extension Overview {
    enum Interactor {
        protocol Interface: Sendable {
            func getOverview() async throws -> Model
        }
    }
}
