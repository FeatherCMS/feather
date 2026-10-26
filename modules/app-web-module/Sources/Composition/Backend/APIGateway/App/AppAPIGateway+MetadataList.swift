public import WebAppAPI
import WebApplication

extension AppAPIGateway {
    public func metadataList(
        _ input: Operations.MetadataList.Input
    ) async throws -> Operations.MetadataList.Output {
        let output = try await useCases.makeListPublicMetadata().execute()
        return .ok(
            .init(
                body: .json(output.slugs)
            )
        )
    }
}
