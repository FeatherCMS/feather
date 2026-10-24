import FeatherModuleKit
public import MediaAdminAPI
import MediaApplication

extension AdminAPIGateway {
    public func mediaVariantProcessorDelete(
        _ input: Operations.MediaVariantProcessorDelete.Input
    ) async throws -> Operations.MediaVariantProcessorDelete.Output {
        let body: Components.Schemas.DeleteRequestSchema
        switch input.body {
        case .json(let value): body = value
        }
        let subject = try await CurrentSubject.require()
        _ = try await useCases.makeRemoveVariantProcessor()
            .execute(
                subject: subject,
                input: .init(
                    variantId: input.path.mediaVariantId,
                    ids: body.ids
                )
            )
        return .noContent(.init())
    }
}
