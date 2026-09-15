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
import WebBuilders
import WebComponents
import WebFrontend

struct AdminViewBlogTagDefaultInteractor: AdminViewBlogTagInteractor {
    let repository: any AdminViewBlogTagRepository

    func execute(
        entity: AdminViewBlogTagModel
    ) async throws -> BlogTagDetailsModel {
        try await repository.get(id: entity.id)
    }
}
