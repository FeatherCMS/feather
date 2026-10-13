import FeatherAdmin

protocol AdminEditSystemVariableInteractor: Sendable {

    func load(
        id: String
    ) async throws -> SystemVariableEditModel

    func edit(
        id: String,
        input: SystemVariableEditFormInput
    ) async throws
}
