import FeatherModuleKit
import FeatherWebAdmin
import OpenAPIRuntime
import WebModule

struct AdminEditMetadataDefaultInteractor:
    AdminEditMetadataInteractor
{
    let repository: any AdminEditMetadataRepository
    let events: any EventPublisher

    func getTemplateOptions() async throws -> [PageTemplateOption] {
        let providers = try await events.trigger(
            event: TemplateProviderEvent(),
            using: WebModule.Event.Context()
        )
        return
            providers
            .flatMap(\.templates)
            .map { .init(value: $0.id, title: $0.title) }
    }

    func load(
        id: String
    ) async throws -> MetadataDetailsModel {
        try await repository.load(id: id)
    }

    func load(
        referenceType: String,
        referenceID: String
    ) async throws -> MetadataDetailsModel {
        try await repository.load(
            referenceType: referenceType,
            referenceID: referenceID
        )
    }

    func update(
        id: String,
        input: MetadataFormInput
    ) async throws {
        try await repository.update(id: id, input: input)
    }
}
