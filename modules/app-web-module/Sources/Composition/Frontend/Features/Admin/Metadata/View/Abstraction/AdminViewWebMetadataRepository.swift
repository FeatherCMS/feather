import FeatherAdmin
import Foundation
import OpenAPIRuntime

protocol AdminViewWebMetadataRepository: Sendable {

    func get(
        id: String
    ) async throws -> WebMetadataDetailsModel
}
