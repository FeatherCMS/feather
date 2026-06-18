import Hummingbird

struct AdminListBlogTagDefaultInteractor:
    AdminListBlogTagInteractor
{
    let repository: any AdminListBlogTagRepository

    func listBlogTags(
        page: Int,
        search: String?
    ) async throws -> AdminListBlogTagModel {
        try await repository.listBlogTags(page: page, search: search)
    }

    func bulkRemove(
        ids: [String]
    ) async throws {
        for id in ids {
            try await repository.delete(id: id)
        }
    }
}
