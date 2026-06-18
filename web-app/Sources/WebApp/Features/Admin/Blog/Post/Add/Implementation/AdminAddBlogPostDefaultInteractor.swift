import Foundation

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
