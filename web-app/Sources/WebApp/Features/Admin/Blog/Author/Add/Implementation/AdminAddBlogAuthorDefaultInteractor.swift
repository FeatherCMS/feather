import Foundation

struct AdminAddBlogAuthorDefaultInteractor: AdminAddBlogAuthorInteractor {
    let repository: any AdminAddBlogAuthorRepository

    func execute(
        input: BlogAuthorFormInput
    ) async throws {
        try await repository.create(input: input)
    }
}
