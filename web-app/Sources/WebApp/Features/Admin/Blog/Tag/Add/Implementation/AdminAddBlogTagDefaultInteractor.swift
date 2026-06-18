import Foundation

struct AdminAddBlogTagDefaultInteractor: AdminAddBlogTagInteractor {
    let repository: any AdminAddBlogTagRepository

    func execute(
        input: BlogTagFormInput
    ) async throws {
        try await repository.create(input: input)
    }
}
