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
import WebFrontend
import WebStandards

struct AdminGetBlogAuthorLinkDefaultInteractor: AdminGetBlogAuthorLinkInteractor
{
    let repository: any AdminGetBlogAuthorLinkRepository

    func execute(
        entity: AdminGetBlogAuthorLinkModel
    ) async throws -> BlogAuthorLinkDetailsModel {
        try await repository.get(menuId: entity.menuId, id: entity.id)
    }
}
