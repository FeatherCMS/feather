import Foundation

protocol AdminEditWebPageInteractor: Sendable {

    func load(
        id: String
    ) async throws -> WebPageDetailsModel

    func update(
        id: String,
        input: WebPageFormInput
    ) async throws
}
