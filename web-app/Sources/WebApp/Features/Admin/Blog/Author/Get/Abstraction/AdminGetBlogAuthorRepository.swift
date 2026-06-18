import Foundation

protocol AdminGetBlogAuthorRepository: Sendable {

    func get(
        id: String
    ) async throws -> BlogAuthorDetailsModel
}
