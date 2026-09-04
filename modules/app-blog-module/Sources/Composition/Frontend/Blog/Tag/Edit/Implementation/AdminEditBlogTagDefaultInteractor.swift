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

struct AdminEditBlogTagDefaultInteractor:
    AdminEditBlogTagInteractor
{
    let repository: any AdminEditBlogTagRepository

    func load(
        id: String
    ) async throws -> BlogTagDetailsModel {
        try await repository.load(id: id)
    }

    func update(
        id: String,
        input: BlogTagFormInput
    ) async throws {
        try await repository.update(id: id, input: input)
    }
}
