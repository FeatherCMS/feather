import Foundation

protocol AdminRemoveBlogAuthorLinkInteractor: Sendable {

    func get(
        menuId: String,
        id: String
    ) async throws -> BlogAuthorLinkDetailsModel

    func delete(
        menuId: String,
        id: String
    ) async throws
}
