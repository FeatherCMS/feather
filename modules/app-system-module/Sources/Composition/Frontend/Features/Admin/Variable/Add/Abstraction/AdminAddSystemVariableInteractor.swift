import FeatherAdmin

protocol AdminAddSystemVariableInteractor: Sendable {

    func add(
        input: SystemVariableAddFormInput
    ) async throws
}
