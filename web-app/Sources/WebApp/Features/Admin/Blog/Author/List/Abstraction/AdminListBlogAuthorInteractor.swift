import Hummingbird

protocol AdminListBlogAuthorInteractor: Sendable {

    func listBlogAuthors(
        page: Int,
        search: String?
    ) async throws -> AdminListBlogAuthorModel

    func bulkRemove(
        ids: [String]
    ) async throws
}
