import Foundation

protocol AdminEditWebMetadataInteractor: Sendable {

    func load(
        id: String
    ) async throws -> WebMetadataDetailsModel

    func update(
        id: String,
        input: WebMetadataFormInput
    ) async throws
}
