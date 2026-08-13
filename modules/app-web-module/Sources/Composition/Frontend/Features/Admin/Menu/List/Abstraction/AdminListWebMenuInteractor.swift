import FeatherAdmin
import Hummingbird
import OpenAPIRuntime

protocol AdminListWebMenuInteractor: Sendable {

    func listWebMenus(
        page: Int,
        search: String?
    ) async throws -> AdminListWebMenuModel

    func bulkRemove(
        ids: [String]
    ) async throws
}
