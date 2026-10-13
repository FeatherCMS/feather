import BlogAdminAPI
import BlogAppAPI
import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import MediaFrontend
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebFrontend

struct AdminViewBlogPostDefaultInteractor: AdminViewBlogPostInteractor {
    let repository: any AdminViewBlogPostRepository

    func execute(
        entity: AdminViewBlogPostModel
    ) async throws -> BlogPostDetailsModel {
        try await repository.get(id: entity.id)
    }
}
