import FeatherWebAdmin
import SystemModule

extension Variable.View {
    enum Repository {}
}

extension Variable.View.Repository {
    protocol Interface: Sendable {

        func get(
            id: String
        ) async throws -> Variable.View.Result
    }
}
