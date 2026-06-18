import Foundation

protocol AdminAddBlogTagInteractor: Sendable {

    func execute(
        input: BlogTagFormInput
    ) async throws
}
