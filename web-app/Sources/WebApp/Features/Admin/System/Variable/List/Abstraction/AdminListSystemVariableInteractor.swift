import Hummingbird

protocol AdminListSystemVariableInteractor: Sendable {

    func listSystemVariables(
        page: Int,
        search: String?
    ) async throws -> AdminListSystemVariableModel

    func bulkRemove(
        ids: [String]
    ) async throws
}
