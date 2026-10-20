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

struct AdminRemoveBlogAuthorLinkDefaultInteractor:
    AdminRemoveBlogAuthorLinkInteractor
{
    let repository: any AdminRemoveBlogAuthorLinkRepository

    func get(
        menuId: String,
        id: String
    ) async throws -> BlogAuthorLinkDetailsModel {
        try await repository.get(menuId: menuId, id: id)
    }

    func delete(
        menuId: String,
        id: String
    ) async throws {
        try await repository.delete(menuId: menuId, id: id)
    }

    func delete(menuId: String, ids: [String]) async throws {
        for id in ids {
            try await repository.delete(menuId: menuId, id: id)
        }
    }
}
