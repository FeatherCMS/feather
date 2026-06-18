import Foundation

protocol AdminAddWebMenuRepository: Sendable {

    func create(
        input: WebMenuFormInput
    ) async throws
}
