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

    func remove(
        ids: [String]
    ) async throws {
        for id in ids {
            try await repository.delete(id: id)
        }
    }
}
