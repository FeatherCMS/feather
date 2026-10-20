import BlogAdminAPI
import BlogAppAPI
import FeatherWebAdmin
import FeatherValidation
import HTML
import Hummingbird
import MediaFrontend
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebFrontend

struct AdminListBlogPostDefaultInteractor:
    AdminListBlogPostInteractor
{
    let repository: any AdminListBlogPostRepository

    func listBlogPosts(
        page: Int,
        search: String?
    ) async throws -> AdminListBlogPostModel {
        try await repository.listBlogPosts(page: page, search: search)
    }

}
