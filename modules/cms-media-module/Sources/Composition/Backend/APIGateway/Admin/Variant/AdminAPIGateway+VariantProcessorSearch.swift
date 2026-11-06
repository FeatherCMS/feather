import FeatherApplication
import FeatherModuleKit
public import MediaAdminAPI
import MediaApplication
import MediaModule

extension AdminAPIGateway {
    public func mediaVariantProcessorQuery(
        _ input: Operations.MediaVariantProcessorQuery.Input
    ) async throws -> Operations.MediaVariantProcessorQuery.Output {
        let query:
            Components.Schemas
                .MediaVariantProcessorQueryItemSearchRequestQuerySchema
        switch input.body {
        case .json(let value): query = value
        }
        let subject = try await CurrentSubject.require()
        let useCase = useCases.makeSearchVariantProcessors()
        let objectQuery = Variant.Processor.Search.Input.Query(
            page: Search.Page(
                size: query.page?.size ?? 20,
                number: query.page?.number ?? 1
            ),
            search: query.filters.search
        )
        do {
            let result = try await useCase.execute(
                subject: subject,
                input: .init(
                    variantId: input.path.mediaVariantId,
                    query: objectQuery
                )
            )
            return .ok(
                .init(
                    body: .json(
                        .init(
                            query: .init(
                                page: .init(
                                    size: query.page?.size ?? 20,
                                    number: query.page?.number ?? 1
                                ),
                                sort: query.sort?
                                    .map { rule in
                                        let field:
                                            Components.Schemas
                                                .MediaVariantProcessorQueryItemSearchResponseQuerySchema
                                                .SortPayloadPayload.FieldPayload
                                        switch rule.field {
                                        case .id: field = .id
                                        case .name: field = .name
                                        case .matchExtensions:
                                            field = .matchExtensions
                                        case .commandTemplate:
                                            field = .commandTemplate
                                        case .isActive: field = .isActive
                                        }
                                        return .init(
                                            field: field,
                                            direction: rule.direction
                                        )
                                    },
                                filters: .init(search: query.filters.search)
                            ),
                            data: .init(
                                items: result.items.map {
                                    .init(
                                        id: $0.id,
                                        name: $0.name,
                                        matchExtensions: $0.matchExtensions,
                                        commandTemplate: $0.commandTemplate,
                                        isActive: $0.isActive
                                    )
                                },
                                total: result.total
                            )
                        )
                    )
                )
            )
        }
        catch Variant.Processor.Search.Error.variantNotFound {
            return .notFound(
                .init(
                    body: .json(
                        .init(
                            error: .init(
                                message: "Media variant not found.",
                                reason: "media_variant_not_found"
                            )
                        )
                    )
                )
            )
        }
    }
}
