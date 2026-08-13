import FeatherAdmin
import Foundation
import OpenAPIRuntime

protocol AdminGetWebMetadataRepository: Sendable {

    func get(
        id: String
    ) async throws -> WebMetadataDetailsModel
}
