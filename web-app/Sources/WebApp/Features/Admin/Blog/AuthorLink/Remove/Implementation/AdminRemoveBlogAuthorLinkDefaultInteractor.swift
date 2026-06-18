import Foundation

struct AdminRemoveBlogAuthorLinkDefaultInteractor:
    AdminRemoveBlogAuthorLinkInteractor
{
    let repository: any AdminRemoveBlogAuthorLinkRepository

    func get(
        menuId: String,
        id: String
    ) async throws -> BlogAuthorLinkDetailsModel {
        try await repository.get(menuId: menuId, id: id)
    }

    func delete(
        menuId: String,
        id: String
    ) async throws {
        try await repository.delete(menuId: menuId, id: id)
    }
}
