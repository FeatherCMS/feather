import FeatherWebAdmin
import Hummingbird
import OpenAPIRuntime

protocol AdminListWebMenuRepository: Sendable {

    func listWebMenus(
        page: Int,
        search: String?
    ) async throws -> AdminListWebMenuModel

}
