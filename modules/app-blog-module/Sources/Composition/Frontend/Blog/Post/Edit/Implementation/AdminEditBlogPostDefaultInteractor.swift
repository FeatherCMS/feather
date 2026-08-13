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

struct AdminEditBlogPostDefaultInteractor:
    AdminEditBlogPostInteractor
{
    let repository: any AdminEditBlogPostRepository
    let optionRepository: any AdminEditBlogPostOptionRepository

    func load(
        id: String
    ) async throws -> BlogPostDetailsModel {
        try await repository.load(id: id)
    }

    func loadOptions() async throws -> BlogPostAssociationOptionsModel {
        try await optionRepository.loadOptions()
    }

    func update(
        id: String,
        input: BlogPostFormInput
    ) async throws {
        try await repository.update(id: id, input: input)
    }
}
