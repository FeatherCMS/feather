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

struct AdminRemoveBlogAuthorDefaultInteractor:
    AdminRemoveBlogAuthorInteractor
{
    let repository: any AdminRemoveBlogAuthorRepository

    func get(
        id: String
    ) async throws -> BlogAuthorDetailsModel {
        try await repository.get(id: id)
    }

    func delete(
        id: String
    ) async throws {
        try await repository.delete(id: id)
    }
}
