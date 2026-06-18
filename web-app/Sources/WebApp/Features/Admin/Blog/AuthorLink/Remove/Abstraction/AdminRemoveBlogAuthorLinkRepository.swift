import Foundation

protocol AdminRemoveBlogAuthorLinkRepository: Sendable {

    func get(
        menuId: String,
        id: String
    ) async throws -> BlogAuthorLinkDetailsModel

    func delete(
        menuId: String,
        id: String
    ) async throws
}
