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
        return .ok(
            .init(
                body: .json(
                    .init(
                        id: result.id,
                        key: result.key,
                        name: result.name,
                        isRequired: result.isRequired,
                        isActive: result.isActive,
                        processors: result.processors.map {
                            .init(
                                id: $0.id,
                                name: $0.name,
                                matchExtensions: $0.matchExtensions,
                                commandTemplate: $0.commandTemplate,
                                isActive: $0.isActive
                            )
                        },
                        createdAt: result.createdAt.timeIntervalSince1970,
                        updatedAt: result.updatedAt.timeIntervalSince1970
                    )
                )
            )
        )
    }
}
