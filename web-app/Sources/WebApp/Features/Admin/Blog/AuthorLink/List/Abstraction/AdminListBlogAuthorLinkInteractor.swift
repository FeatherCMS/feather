import Hummingbird

protocol AdminListBlogAuthorLinkInteractor: Sendable {

    func listBlogAuthorLinks(
        menuId: String,
        page: Int,
        search: String?
    ) async throws -> AdminListBlogAuthorLinkModel

    func bulkRemove(
        menuId: String,
        ids: [String]
    ) async throws
}
