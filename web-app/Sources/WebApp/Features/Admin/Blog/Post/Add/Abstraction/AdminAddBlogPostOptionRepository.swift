import Foundation

protocol AdminAddBlogPostOptionRepository: Sendable {

    func loadOptions() async throws -> BlogPostAssociationOptionsModel
}
