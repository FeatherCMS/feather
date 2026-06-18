import Foundation

protocol AdminEditBlogPostInteractor: Sendable {

    func load(
        id: String
    ) async throws -> BlogPostDetailsModel

    func loadOptions() async throws -> BlogPostAssociationOptionsModel

    func update(
        id: String,
        input: BlogPostFormInput
    ) async throws
}
