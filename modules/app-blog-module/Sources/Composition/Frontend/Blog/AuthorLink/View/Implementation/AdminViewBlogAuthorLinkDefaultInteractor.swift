import BlogAdminAPI
import BlogAppAPI
import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaFrontend
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebFrontend

struct AdminViewBlogAuthorLinkDefaultInteractor:
    AdminViewBlogAuthorLinkInteractor
{
    let repository: any AdminViewBlogAuthorLinkRepository

    func execute(
        entity: AdminViewBlogAuthorLinkModel
    ) async throws -> BlogAuthorLinkDetailsModel {
        try await repository.get(menuId: entity.menuId, id: entity.id)
    }
}
