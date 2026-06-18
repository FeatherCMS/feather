import Foundation

protocol AdminGetBlogAuthorInteractor: Sendable {

    func execute(
        entity: AdminGetBlogAuthorModel
    ) async throws -> BlogAuthorDetailsModel
}
