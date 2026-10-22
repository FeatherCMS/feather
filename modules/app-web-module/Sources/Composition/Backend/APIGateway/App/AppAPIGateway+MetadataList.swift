public import WebAppAPI
import WebApplication

extension AppAPIGateway {
    public func webMetadataList(
        _ input: Operations.WebMetadataList.Input
    ) async throws -> Operations.WebMetadataList.Output {
        let output = try await useCases.makeListPublicMetadata().execute()
        return .ok(
            .init(
                body: .json(output.slugs)
            )
        )
    }
}
