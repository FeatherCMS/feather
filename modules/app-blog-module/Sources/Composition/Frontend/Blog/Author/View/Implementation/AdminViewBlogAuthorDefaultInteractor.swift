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

struct AdminViewBlogAuthorDefaultInteractor: AdminViewBlogAuthorInteractor {
    let repository: any AdminViewBlogAuthorRepository

    func execute(
        entity: AdminViewBlogAuthorModel
    ) async throws -> BlogAuthorDetailsModel {
        try await repository.get(id: entity.id)
    }
}
