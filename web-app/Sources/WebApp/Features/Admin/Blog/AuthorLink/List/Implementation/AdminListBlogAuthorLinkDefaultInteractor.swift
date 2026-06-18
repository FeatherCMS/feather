import Hummingbird

struct AdminListBlogAuthorLinkDefaultInteractor:
    AdminListBlogAuthorLinkInteractor
{
    let repository: any AdminListBlogAuthorLinkRepository

    func listBlogAuthorLinks(
        menuId: String,
        page: Int,
        search: String?
    ) async throws -> AdminListBlogAuthorLinkModel {
        try await repository.listBlogAuthorLinks(
            menuId: menuId,
            page: page,
            search: search
        )
    }

    func bulkRemove(
        menuId: String,
        ids: [String]
    ) async throws {
        for id in ids {
            try await repository.delete(menuId: menuId, id: id)
        }
    }
}
