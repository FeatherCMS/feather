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

struct AdminListBlogTagDefaultInteractor:
    AdminListBlogTagInteractor
{
    let repository: any AdminListBlogTagRepository

    func listBlogTags(
        page: Int,
        search: String?
    ) async throws -> AdminListBlogTagModel {
        try await repository.listBlogTags(page: page, search: search)
    }

    func remove(
        ids: [String]
    ) async throws {
        for id in ids {
            try await repository.delete(id: id)
        }
    }
}
