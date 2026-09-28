import FeatherAdmin
import Hummingbird
import OpenAPIRuntime

struct AdminListWebPageDefaultInteractor:
    AdminListWebPageInteractor
{
    let repository: any AdminListWebPageRepository

    func listWebPages(
        page: Int,
        search: String?
    ) async throws -> AdminListWebPageModel {
        try await repository.listWebPages(page: page, search: search)
    }

    func resolveRemoveItems(
        ids: [String]
    ) async throws -> [NewAdminRemoveItemContext] {
        var items: [NewAdminRemoveItemContext] = []
        items.reserveCapacity(ids.count)
        for id in ids {
            let title: String
            do {
                title = try await repository.title(id: id)
            }
            catch let error as OpenAPIRepositoryError {
                if case .notFound = error {
                    title = id
                }
                else {
                    throw error
                }
            }
            items.append(.init(id: id, label: title))
        }
        return items
    }

    func remove(
        ids: [String]
    ) async throws {
        for id in ids {
            try await repository.delete(id: id)
        }
    }
}
