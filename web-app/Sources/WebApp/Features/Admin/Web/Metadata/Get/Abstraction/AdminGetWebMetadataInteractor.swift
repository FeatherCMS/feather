import Foundation

protocol AdminGetWebMetadataInteractor: Sendable {

    func execute(
        entity: AdminGetWebMetadataModel
    ) async throws -> WebMetadataDetailsModel
}
