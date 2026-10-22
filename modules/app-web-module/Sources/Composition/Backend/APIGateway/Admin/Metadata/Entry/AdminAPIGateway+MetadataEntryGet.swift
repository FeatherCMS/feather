import FeatherModuleKit
public import WebAdminAPI
import WebApplication

extension AdminAPIGateway {

    public func metadataGet(
        _ input: Operations.MetadataGet.Input
    ) async throws -> Operations.MetadataGet.Output {
        let subject = try await CurrentSubject.require()
        let useCase = useCases.makeGetMetadata()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(id: input.path.metadataId)
        )

        return .ok(
            .init(
                body: .json(map(result))
            )
        )
    }
}
