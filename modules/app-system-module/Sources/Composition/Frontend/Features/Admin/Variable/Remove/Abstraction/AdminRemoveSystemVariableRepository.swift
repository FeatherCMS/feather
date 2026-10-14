import FeatherAdmin

protocol AdminRemoveSystemVariableRepository: Sendable {

    func delete(
        ids: [String]
    ) async throws
}
