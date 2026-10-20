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

}
