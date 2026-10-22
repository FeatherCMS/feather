import FeatherWebAdmin
import OpenAPIRuntime
import WebModule

protocol AdminEditWebMetadataInteractor: Sendable {

    func getTemplateOptions() async throws -> [WebPageTemplateOption]

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
