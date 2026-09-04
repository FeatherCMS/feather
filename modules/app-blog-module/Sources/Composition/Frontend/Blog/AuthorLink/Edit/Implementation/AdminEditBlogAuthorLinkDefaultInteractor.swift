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
import WebComponents
import WebBuilders

struct AdminEditBlogAuthorLinkDefaultInteractor:
    AdminEditBlogAuthorLinkInteractor
{
    let repository: any AdminEditBlogAuthorLinkRepository

    func load(
        menuId: String,
        id: String
    ) async throws -> BlogAuthorLinkDetailsModel {
        try await repository.load(menuId: menuId, id: id)
    }

    func update(
        menuId: String,
        id: String,
        input: BlogAuthorLinkFormInput
    ) async throws {
        try await repository.update(menuId: menuId, id: id, input: input)
    }
}
