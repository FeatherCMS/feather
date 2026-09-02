import WebAdminAPI
import WebApplication

extension AdminAPIGateway {

    public func webMetadataList(
        _ input: Operations.WebMetadataList.Input
    ) async throws -> Operations.WebMetadataList.Output {
        .ok(
            .init(
                body: .json(.init())
            )
        )
    }
}
