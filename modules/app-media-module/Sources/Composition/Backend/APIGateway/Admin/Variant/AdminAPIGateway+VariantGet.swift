import FeatherContracts
import MediaAdminAPI
import MediaApplication

extension AdminAPIGateway {
    public func mediaVariantGet(_ input: Operations.MediaVariantGet.Input)
        async throws -> Operations.MediaVariantGet.Output
    {
        let subject = try await CurrentSubject.require()
        guard
            let result = try await useCases.makeGetVariant()
                .execute(
                    subject: subject,
                    input: .init(id: input.path.mediaVariantId)
                )
        else { return .notFound }
        return .ok(.init(body: .json(map(result))))
    }
}
