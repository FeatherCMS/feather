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

struct AdminEditBlogAuthorDefaultInteractor:
    AdminEditBlogAuthorInteractor
{
    let repository: any AdminEditBlogAuthorRepository

    func load(
        id: String
    ) async throws -> BlogAuthorDetailsModel {
        try await repository.load(id: id)
    }

    func update(
        id: String,
        input: BlogAuthorFormInput
    ) async throws {
        try await repository.update(id: id, input: input)
    }
}
