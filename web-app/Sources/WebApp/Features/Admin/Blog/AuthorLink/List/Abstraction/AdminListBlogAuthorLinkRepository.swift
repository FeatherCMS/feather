import Hummingbird

protocol AdminListBlogAuthorLinkRepository: Sendable {

    func listBlogAuthorLinks(
        menuId: String,
        page: Int,
        search: String?
    ) async throws -> AdminListBlogAuthorLinkModel

    func delete(
        menuId: String,
        id: String
    ) async throws
}
