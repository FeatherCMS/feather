import Foundation

protocol AdminEditBlogPostOptionRepository: Sendable {

    func loadOptions() async throws -> BlogPostAssociationOptionsModel
}
