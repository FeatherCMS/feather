import Hummingbird

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

    func bulkRemove(
        ids: [String]
    ) async throws {
        for id in ids {
            try await repository.delete(id: id)
        }
    }
}
