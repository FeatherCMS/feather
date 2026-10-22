import FeatherModuleKit
public import WebAdminAPI
import WebApplication

extension AdminAPIGateway {

    public func metadataList(
        _ input: Operations.MetadataList.Input
    ) async throws -> Operations.MetadataList.Output {
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
