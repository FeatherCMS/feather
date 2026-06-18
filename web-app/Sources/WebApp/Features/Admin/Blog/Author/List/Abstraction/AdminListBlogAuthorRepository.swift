import Hummingbird

protocol AdminListBlogAuthorRepository: Sendable {

    func listBlogAuthors(
        page: Int,
        search: String?
    ) async throws -> AdminListBlogAuthorModel

    func delete(
        id: String
    ) async throws
}
