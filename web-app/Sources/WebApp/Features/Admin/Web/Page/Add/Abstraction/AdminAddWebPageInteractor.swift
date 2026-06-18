import Foundation

protocol AdminAddWebPageInteractor: Sendable {

    func execute(
        input: WebPageFormInput
    ) async throws
}
