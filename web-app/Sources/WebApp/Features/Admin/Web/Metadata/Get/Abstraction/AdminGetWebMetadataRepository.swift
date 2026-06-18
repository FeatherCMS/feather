import Foundation

protocol AdminGetWebMetadataRepository: Sendable {

    func get(
        id: String
    ) async throws -> WebMetadataDetailsModel
}
