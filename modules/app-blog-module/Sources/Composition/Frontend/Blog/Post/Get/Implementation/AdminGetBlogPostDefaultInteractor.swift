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

struct AdminGetBlogPostDefaultInteractor: AdminGetBlogPostInteractor {
    let repository: any AdminGetBlogPostRepository

    func execute(
        entity: AdminGetBlogPostModel
    ) async throws -> BlogPostDetailsModel {
        try await repository.get(id: entity.id)
    }
}
