import FeatherAdmin
import Hummingbird
import OpenAPIRuntime

protocol AdminListWebMenuRepository: Sendable {

    func listWebMenus(
        page: Int,
        search: String?
    ) async throws -> AdminListWebMenuModel

    func delete(
        id: String
    ) async throws
}
