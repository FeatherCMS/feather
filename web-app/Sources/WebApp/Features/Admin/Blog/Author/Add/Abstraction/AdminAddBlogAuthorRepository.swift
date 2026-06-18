import Foundation

protocol AdminAddBlogAuthorRepository: Sendable {

    func create(
        input: BlogAuthorFormInput
    ) async throws
}
