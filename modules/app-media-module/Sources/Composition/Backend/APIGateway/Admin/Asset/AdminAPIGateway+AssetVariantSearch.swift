import FeatherApplication
import FeatherContracts
import MediaAdminAPI

extension AdminAPIGateway {
    public func mediaAssetVariantSearch(
        _ input: Operations.MediaAssetVariantSearch.Input
    ) async throws -> Operations.MediaAssetVariantSearch.Output {
        _ = try await CurrentSubject.require()
        do {
            let items = try await useCases.listAssociatedVariantFiles(
                assetId: input.path.mediaAssetId
            )
            return .ok(
                .init(
                    body: .json(
                        .init(
                            items: items.map(map)
                        )
                    )
                )
            )
        }
        catch {
            return .notFound(.init())
        }
    }
}
