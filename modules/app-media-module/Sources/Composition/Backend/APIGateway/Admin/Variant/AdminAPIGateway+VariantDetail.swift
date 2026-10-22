import FeatherModuleKit
public import MediaAdminAPI
import MediaApplication

extension AdminAPIGateway {
    public func mediaVariantGet(_ input: Operations.MediaVariantGet.Input)
        async throws -> Operations.MediaVariantGet.Output
    {
        let subject = try await CurrentSubject.require()
        guard
            let result = try await useCases.makeDetailVariant()
                .execute(
                    subject: subject,
                    input: .init(id: input.path.mediaVariantId)
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
