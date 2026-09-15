import FeatherAdmin
import SystemAdminAPI

protocol AdminListSystemJobInteractor: Sendable {
    func list(
        page: Int,
        search: String?
    ) async throws -> AdminListSystemJobModel
}
