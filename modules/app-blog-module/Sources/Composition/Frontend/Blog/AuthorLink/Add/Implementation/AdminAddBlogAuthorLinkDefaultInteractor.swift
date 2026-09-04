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

struct AdminAddBlogAuthorLinkDefaultInteractor: AdminAddBlogAuthorLinkInteractor
{
    let repository: any AdminAddBlogAuthorLinkRepository

    func execute(
        menuId: String,
        input: BlogAuthorLinkFormInput
    ) async throws {
        try await repository.create(menuId: menuId, input: input)
    }
}
