import Hummingbird

struct AdminListBlogAuthorDefaultInteractor:
    AdminListBlogAuthorInteractor
{
    let repository: any AdminListBlogAuthorRepository

    func listBlogAuthors(
        page: Int,
        search: String?
    ) async throws -> AdminListBlogAuthorModel {
        try await repository.listBlogAuthors(page: page, search: search)
    }

    func bulkRemove(
        ids: [String]
    ) async throws {
        for id in ids {
            try await repository.delete(id: id)
        }
    }
}
