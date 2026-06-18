import Foundation

protocol AdminAddBlogPostInteractor: Sendable {

    func loadOptions() async throws -> BlogPostAssociationOptionsModel

    func execute(
        input: BlogPostFormInput
    ) async throws
}
