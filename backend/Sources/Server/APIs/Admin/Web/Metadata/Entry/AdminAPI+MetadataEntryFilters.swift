import AdminOpenAPI
import WebApplication

extension AdminAPI {

    func webMetadataFilters(
        _ input: Operations.WebMetadataFilters.Input
    ) async throws -> Operations.WebMetadataFilters.Output {
        .ok(
            .init(
                body: .json(.init())
            )
        )
    }
}
