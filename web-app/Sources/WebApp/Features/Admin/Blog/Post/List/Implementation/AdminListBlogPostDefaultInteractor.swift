import Hummingbird

struct AdminListBlogPostDefaultInteractor:
    AdminListBlogPostInteractor
{
    let repository: any AdminListBlogPostRepository

    func listBlogPosts(
        page: Int,
        search: String?
    ) async throws -> AdminListBlogPostModel {
        try await repository.listBlogPosts(page: page, search: search)
    }

    func bulkRemove(
        ids: [String]
    ) async throws {
        for id in ids {
            try await repository.delete(id: id)
        }
    }
}
