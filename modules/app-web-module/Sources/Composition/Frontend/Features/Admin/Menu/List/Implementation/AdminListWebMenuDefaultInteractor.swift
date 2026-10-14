import FeatherAdmin
import Hummingbird
import OpenAPIRuntime

struct AdminListWebMenuDefaultInteractor:
    AdminListWebMenuInteractor
{
    let repository: any AdminListWebMenuRepository

    func listWebMenus(
        page: Int,
        search: String?
    ) async throws -> AdminListWebMenuModel {
        try await repository.listWebMenus(page: page, search: search)
    }

}
