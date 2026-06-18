import Foundation

protocol AdminAddWebMenuInteractor: Sendable {

    func execute(
        input: WebMenuFormInput
    ) async throws
}
