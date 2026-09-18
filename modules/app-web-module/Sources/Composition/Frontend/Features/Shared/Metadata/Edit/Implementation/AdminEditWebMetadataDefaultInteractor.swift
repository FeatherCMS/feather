import FeatherAdmin
import FeatherContracts
import Foundation
import OpenAPIRuntime
import WebContracts

struct AdminEditWebMetadataDefaultInteractor:
    AdminEditWebMetadataInteractor
{
    let repository: any AdminEditWebMetadataRepository
    let events: any EventPublisher

    func getTemplateOptions() async throws -> [WebPageTemplateOption] {
        let providers = try await events.trigger(
            event: WebTemplateProviderEvent(),
            using: WebEventContext()
        )
        return
            providers
            .flatMap(\.templates)
            .map { .init(value: $0.id, title: $0.title) }
    }

    func load(
        id: String
    ) async throws -> WebMetadataDetailsModel {
        try await repository.load(id: id)
    }

    func load(
        referenceType: String,
        referenceID: String
    ) async throws -> WebMetadataDetailsModel {
        try await repository.load(
            referenceType: referenceType,
            referenceID: referenceID
        )
    }

    func update(
        id: String,
        input: WebMetadataFormInput
    ) async throws {
        try await repository.update(id: id, input: input)
    }
}
