import FeatherModuleKit
public import WebAdminAPI
import WebApplication

extension AdminAPIGateway {

    public func webMetadataList(
        _ input: Operations.WebMetadataList.Input
    ) async throws -> Operations.WebMetadataList.Output {
        let subject = try await CurrentSubject.require()
        let result = try await useCases.makeListMetadata()
            .execute(subject: subject)
        return .ok(
            .init(
                body: .json(result.items.map(map))
            )
        )
    }
}
