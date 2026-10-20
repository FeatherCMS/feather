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

    func delete(ids: [String]) async throws {
        for id in ids {
            try await repository.delete(id: id)
        }
    }
}
