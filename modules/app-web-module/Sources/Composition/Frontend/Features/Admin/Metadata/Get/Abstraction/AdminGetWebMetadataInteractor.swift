import FeatherAdmin
import Foundation
import OpenAPIRuntime

protocol AdminGetWebMetadataInteractor: Sendable {

    func execute(
        entity: AdminGetWebMetadataModel
    ) async throws -> WebMetadataDetailsModel
}
