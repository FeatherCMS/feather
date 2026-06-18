import Foundation

protocol AdminGetBlogAuthorLinkRepository: Sendable {

    func get(
        menuId: String,
        id: String
    ) async throws -> BlogAuthorLinkDetailsModel
}
