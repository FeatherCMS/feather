import Hummingbird

protocol AdminListSystemVariableRepository: Sendable {

    func listSystemVariables(
        page: Int,
        search: String?
    ) async throws -> AdminListSystemVariableModel

    func delete(
        id: String
    ) async throws
}
