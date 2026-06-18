import Foundation

protocol AdminAddWebPageRepository: Sendable {

    func create(
        input: WebPageFormInput
    ) async throws
}
