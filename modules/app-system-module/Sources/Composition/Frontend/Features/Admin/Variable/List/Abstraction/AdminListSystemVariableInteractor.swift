import FeatherAdmin
import Hummingbird

protocol AdminListSystemVariableInteractor: Sendable {

    func listSystemVariables(
        page: Int,
        search: String?
    ) async throws -> AdminListSystemVariableModel

    func remove(
        ids: [String]
    ) async throws
}
