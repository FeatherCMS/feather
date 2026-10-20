import FeatherWebAdmin
import Hummingbird
import OpenAPIRuntime

protocol AdminListWebMenuInteractor: Sendable {

    func listWebMenus(
        page: Int,
        search: String?
    ) async throws -> AdminListWebMenuModel

}
