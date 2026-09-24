import FeatherAdmin

protocol AdminViewSystemVariableInteractor: Sendable {

    func execute(
        entity: AdminViewSystemVariableModel
    ) async throws -> SystemVariableDetailsModel
}
