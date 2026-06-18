import Hummingbird

protocol AdminListBlogTagInteractor: Sendable {

    func listBlogTags(
        page: Int,
        search: String?
    ) async throws -> AdminListBlogTagModel

    func bulkRemove(
        ids: [String]
    ) async throws
}
