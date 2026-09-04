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

struct AdminGetBlogTagDefaultInteractor: AdminGetBlogTagInteractor {
    let repository: any AdminGetBlogTagRepository

    func execute(
        entity: AdminGetBlogTagModel
    ) async throws -> BlogTagDetailsModel {
        try await repository.get(id: entity.id)
    }
}
