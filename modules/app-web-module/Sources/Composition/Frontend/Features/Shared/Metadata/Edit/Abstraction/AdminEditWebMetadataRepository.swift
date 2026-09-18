import FeatherAdmin
import Foundation
import OpenAPIRuntime

protocol AdminEditWebMetadataRepository: Sendable {

    func load(
        id: String
    ) async throws -> WebMetadataDetailsModel

    func load(
        referenceType: String,
        referenceID: String
    ) async throws -> WebMetadataDetailsModel

    func update(
        id: String,
        input: WebMetadataFormInput
    ) async throws
}
