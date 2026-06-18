import Hummingbird

protocol AdminListBlogTagRepository: Sendable {

    func listBlogTags(
        page: Int,
        search: String?
    ) async throws -> AdminListBlogTagModel

    func delete(
        id: String
    ) async throws
}
