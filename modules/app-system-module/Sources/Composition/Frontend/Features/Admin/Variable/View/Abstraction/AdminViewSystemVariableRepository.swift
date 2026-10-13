import FeatherAdmin

protocol AdminViewSystemVariableRepository: Sendable {

    func get(
        id: String
    ) async throws -> SystemVariableDetailsModel
}
