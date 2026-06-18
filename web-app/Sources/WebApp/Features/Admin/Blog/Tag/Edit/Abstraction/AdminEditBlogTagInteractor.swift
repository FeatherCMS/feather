import Foundation

protocol AdminEditBlogTagInteractor: Sendable {

    func load(
        id: String
    ) async throws -> BlogTagDetailsModel

    func update(
        id: String,
        input: BlogTagFormInput
    ) async throws
}
