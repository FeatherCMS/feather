import FeatherAdmin
import Foundation
import OpenAPIRuntime

protocol AdminViewWebMetadataInteractor: Sendable {

    func execute(
        entity: AdminViewWebMetadataModel
    ) async throws -> WebMetadataDetailsModel
}
