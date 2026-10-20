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

struct AdminRemoveBlogTagDefaultInteractor:
    AdminRemoveBlogTagInteractor
{
    let repository: any AdminRemoveBlogTagRepository

    func get(
        id: String
    ) async throws -> BlogTagDetailsModel {
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
