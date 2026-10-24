import FeatherModuleKit
import FeatherWebAdmin
import OpenAPIRuntime
import WebModule

extension WebModule.Metadata.Edit.Interactor {
    struct Default: Interface {
        let repository: any WebModule.Metadata.Edit.Repository.Interface
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
        ) async throws -> WebModule.Metadata.Edit.Model {
            try await repository.load(id: id)
        }

        func load(
            referenceType: String,
            referenceID: String
        ) async throws -> WebModule.Metadata.Edit.Model {
            try await repository.load(
                referenceType: referenceType,
                referenceID: referenceID
            )
        }

        func update(
            id: String,
            input: WebModule.Metadata.Edit.Input
        ) async throws {
            try await repository.update(id: id, input: input)
        }
    }
}
