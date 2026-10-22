import FeatherWebAdmin
import SystemModule

extension Variable.View.Repository {
    protocol Interface: Sendable {

        func get(
            id: String
        ) async throws -> SystemVariableDetailsModel
    }
}
