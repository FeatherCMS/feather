import BlogAdminAPI
import BlogAppAPI
import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import MediaFrontend
import OpenAPIRuntime
import SGML
import WebFrontend
import WebComponents
import WebBuilders

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

    func remove(
        ids: [String]
    ) async throws {
        for id in ids {
            try await repository.delete(id: id)
        }
    }
}
