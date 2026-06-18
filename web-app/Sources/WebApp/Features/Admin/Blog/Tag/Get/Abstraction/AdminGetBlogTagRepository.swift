import Foundation

protocol AdminGetBlogTagRepository: Sendable {

    func get(
        id: String
    ) async throws -> BlogTagDetailsModel
}
