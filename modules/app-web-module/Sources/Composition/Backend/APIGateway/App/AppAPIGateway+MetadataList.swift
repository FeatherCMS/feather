public import WebAppAPI
import WebApplication

extension AppAPIGateway {
    public func webMetadataList(
        _ input: Operations.WebMetadataList.Input
    ) async throws -> Operations.WebMetadataList.Output {
        let items = try await useCases.makeListPublicMetadata().execute()
        return .ok(
            .init(
                body: .json(items.map(\.slug))
            )
        )
    }
}
