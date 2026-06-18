import Hummingbird

protocol AdminListBlogPostRepository: Sendable {

    func listBlogPosts(
        page: Int,
        search: String?
    ) async throws -> AdminListBlogPostModel

    func delete(
        id: String
    ) async throws
}
