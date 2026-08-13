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
}
