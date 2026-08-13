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
}
