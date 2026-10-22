import FeatherModuleKit
public import MediaAdminAPI
import MediaApplication
import MediaModule

extension AdminAPIGateway {
    public func mediaVariantProcessorGet(
        _ input: Operations.MediaVariantProcessorGet.Input
    ) async throws -> Operations.MediaVariantProcessorGet.Output {
        let subject = try await CurrentSubject.require()
        guard
            let result = try await useCases.makeDetailVariantProcessor()
                .execute(
                    subject: subject,
                    input: .init(
                        variantId: input.path.mediaVariantId,
                        id: input.path.mediaVariantProcessorId
                    )
                )
        else {
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
        return .ok(.init(body: .json(map(result))))
    }
}
