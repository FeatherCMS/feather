import Foundation

protocol AdminAddBlogTagRepository: Sendable {

    func create(
        input: BlogTagFormInput
    ) async throws
}
