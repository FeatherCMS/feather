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
import WebStandards

struct AdminGetBlogAuthorDefaultInteractor: AdminGetBlogAuthorInteractor {
    let repository: any AdminGetBlogAuthorRepository

    func execute(
        entity: AdminGetBlogAuthorModel
    ) async throws -> BlogAuthorDetailsModel {
        try await repository.get(id: entity.id)
    }
}
