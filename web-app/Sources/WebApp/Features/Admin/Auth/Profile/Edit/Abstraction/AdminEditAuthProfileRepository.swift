import Foundation

protocol AdminEditAuthProfileRepository: Sendable {

    func update(
        id: String,
        payload: AdminEditAuthProfileFormPayloadModel
    ) async throws
}
