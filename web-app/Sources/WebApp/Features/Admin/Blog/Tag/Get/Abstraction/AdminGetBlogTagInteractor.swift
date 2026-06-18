import Foundation

protocol AdminGetBlogTagInteractor: Sendable {

    func execute(
        entity: AdminGetBlogTagModel
    ) async throws -> BlogTagDetailsModel
}
