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
        let objectQuery = map(query)
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
                            query: responseQuery(from: query),
                            data: .init(
                                items: result.items.map(map),
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
                        errorEnvelope(
                            message: "Media variant not found.",
                            reason: "media_variant_not_found"
                        )
                    )
                )
            )
        }
    }
}
