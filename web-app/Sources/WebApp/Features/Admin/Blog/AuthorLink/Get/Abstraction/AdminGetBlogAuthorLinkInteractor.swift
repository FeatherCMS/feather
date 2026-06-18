import Foundation

protocol AdminGetBlogAuthorLinkInteractor: Sendable {

    func execute(
        entity: AdminGetBlogAuthorLinkModel
    ) async throws -> BlogAuthorLinkDetailsModel
}
