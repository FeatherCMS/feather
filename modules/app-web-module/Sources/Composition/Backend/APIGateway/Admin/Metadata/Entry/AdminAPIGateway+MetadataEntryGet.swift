import FeatherApplication
import FeatherContracts
import WebAdminAPI
import WebApplication

extension AdminAPIGateway {

    public func webMetadataGet(
        _ input: Operations.WebMetadataGet.Input
    ) async throws -> Operations.WebMetadataGet.Output {
        let subject = try await CurrentSubject.require()
        let useCase = useCases.makeGetMetadata()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(id: input.path.webMetadataId)
        )

        return .ok(
            .init(
                body: .json(useCases.map(result))
            )
        )
    }
}
