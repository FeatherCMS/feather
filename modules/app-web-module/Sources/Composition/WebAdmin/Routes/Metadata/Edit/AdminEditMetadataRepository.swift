import FeatherWebAdmin
import OpenAPIRuntime

protocol AdminEditMetadataRepository: Sendable {

    func load(
        id: String
    ) async throws -> MetadataDetailsModel

    func load(
        referenceType: String,
        referenceID: String
    ) async throws -> MetadataDetailsModel

    func update(
        id: String,
        input: MetadataFormInput
    ) async throws
}
