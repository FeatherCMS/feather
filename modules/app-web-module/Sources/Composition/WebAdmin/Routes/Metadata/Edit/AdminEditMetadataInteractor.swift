import FeatherWebAdmin
import OpenAPIRuntime
import WebModule

protocol AdminEditMetadataInteractor: Sendable {

    func getTemplateOptions() async throws -> [PageTemplateOption]

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
