import FeatherModuleKit
public import MediaAdminAPI
import MediaApplication
import MediaModule

extension AdminAPIGateway {
    public func mediaVariantProcessorPost(
        _ input: Operations.MediaVariantProcessorPost.Input
    ) async throws -> Operations.MediaVariantProcessorPost.Output {
        let body: Components.Schemas.MediaVariantProcessorCreateSchema
        switch input.body {
        case .json(let value): body = value
        }
        let subject = try await CurrentSubject.require()
        do {
            let result = try await useCases.makeAddVariantProcessor()
                .execute(
                    subject: subject,
                    input: .init(
                        variantId: input.path.mediaVariantId,
                        name: body.name,
                        matchExtensions: body.matchExtensions,
                        commandTemplate: body.commandTemplate,
                        isActive: body.isActive
                    )
                )
            return .created(.init(body: .json(map(result.detail))))
        }
        catch Variant.Processor.Add.Error.variantNotFound {
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
