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

struct AdminAddBlogPostDefaultInteractor: AdminAddBlogPostInteractor {
    let repository: any AdminAddBlogPostRepository
    let optionRepository: any AdminAddBlogPostOptionRepository

    func loadOptions() async throws -> BlogPostAssociationOptionsModel {
        try await optionRepository.loadOptions()
    }

    func execute(
        input: BlogPostFormInput
    ) async throws {
        try await repository.create(input: input)
    }
}
