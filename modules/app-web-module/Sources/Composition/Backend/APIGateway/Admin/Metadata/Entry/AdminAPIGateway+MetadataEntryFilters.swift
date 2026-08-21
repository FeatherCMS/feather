import WebAdminAPI
import WebApplication

extension AdminAPIGateway {

    public func webMetadataFilters(
        _ input: Operations.WebMetadataFilters.Input
    ) async throws -> Operations.WebMetadataFilters.Output {
        .ok(
            .init(
                body: .json(.init())
            )
        )
    }
}
