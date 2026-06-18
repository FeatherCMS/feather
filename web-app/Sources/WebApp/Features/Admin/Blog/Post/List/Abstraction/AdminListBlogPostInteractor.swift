import Hummingbird

protocol AdminListBlogPostInteractor: Sendable {

    func listBlogPosts(
        page: Int,
        search: String?
    ) async throws -> AdminListBlogPostModel

    func bulkRemove(
        ids: [String]
    ) async throws
}
