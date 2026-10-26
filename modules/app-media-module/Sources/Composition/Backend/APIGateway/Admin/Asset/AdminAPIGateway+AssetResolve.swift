import FeatherModuleKit
import Foundation
public import MediaAdminAPI
import MediaApplication
import MediaModule

extension AdminAPIGateway {

    public func mediaAssetResolve(
        _ input: Operations.MediaAssetResolve.Input
    ) async throws -> Operations.MediaAssetResolve.Output {
        let body: Components.Schemas.MediaAssetResolveRequestSchema
        switch input.body {
        case .json(let value): body = value
        }

        let subject = try await CurrentSubject.require()
        let result = try await useCases.makeResolveAssets()
            .execute(
                subject: subject,
                input: .init(ids: body.ids, variants: body.variants)
            )

        return .ok(
            .init(body: .json(result.items.map(mapResolvedAsset)))
        )
    }

    private func mapResolvedAsset(
        _ item: Asset.File.Resolve.Output.Item
    ) -> Components.Schemas.MediaAssetResolveItemSchema {
        .init(
            id: item.id,
            url: mediaResolver.resolve(imagePath: item.url) ?? item.url,
            _extension: item.extension,
            title: item.title,
            altText: item.altText,
            variants: item.variants.map {
                .init(
                    key: $0.key,
                    name: $0.name,
                    url: mediaResolver.resolve(imagePath: $0.url) ?? $0.url,
                    _extension: $0.extension
                )
            }
        )
    }
}
