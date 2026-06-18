import Foundation

struct AdminGetBlogAuthorLinkDefaultInteractor: AdminGetBlogAuthorLinkInteractor
{
    let repository: any AdminGetBlogAuthorLinkRepository

    func execute(
        entity: AdminGetBlogAuthorLinkModel
    ) async throws -> BlogAuthorLinkDetailsModel {
        try await repository.get(menuId: entity.menuId, id: entity.id)
    }
}
