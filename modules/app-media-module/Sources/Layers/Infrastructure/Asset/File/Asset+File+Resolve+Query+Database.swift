import FeatherApplication
public import FeatherDomain
public import FeatherInfrastructure
public import MediaApplication
public import MediaModule

extension Asset.File.Resolve.Query {
    public struct Database: Interface {
        public let context: DatabaseQueryContext
        public let objectKeyGenerator: any ObjectKeyGenerator

        public init(
            context: DatabaseQueryContext,
            objectKeyGenerator: any ObjectKeyGenerator =
                HierarchicalObjectKeyGenerator()
        ) {
            self.context = context
            self.objectKeyGenerator = objectKeyGenerator
        }

        public func resolve(ids: [String], variants: [String]?) async throws
            -> Asset.File.Resolve.Output
        {
            let assets = try await Asset.File
                .Table(
                    connection: context.connection,
                    context: DatabaseTransactionContext(
                        platform: context.platform,
                        connection: context.connection,
                        idGenerator: context.idGenerator
                    )
                )
                .resolve(ids: ids)
            let variantRows = try await Asset.File
                .VariantResolveQuery(
                    connection: context.connection
                )
                .resolve(nodeIds: ids, variantKeys: variants)
            var variantsByAsset: [String: [Asset.File.Resolve.Output.Variant]] =
                [:]
            var assetsByID: [String: Asset.File.Table.Row] = [:]
            for asset in assets {
                precondition(
                    assetsByID.updateValue(asset, forKey: asset.id) == nil
                )
            }
            for variant in variantRows {
                guard let asset = assetsByID[variant.assetNodeFileId] else {
                    continue
                }
                variantsByAsset[variant.assetNodeFileId, default: []]
                    .append(
                        .init(
                            id: variant.id,
                            key: variant.key,
                            name: variant.name,
                            url: try mediaVariantPublicURL(
                                assetId: variant.assetNodeFileId,
                                slugPath: asset.slugPath,
                                filename: asset.name,
                                variantKey: variant.key,
                                extension: variant.extension,
                                objectKeyGenerator: objectKeyGenerator
                            ),
                            extension: variant.extension
                        )
                    )
            }
            return .init(
                items: try assets.map {
                    .init(
                        id: $0.id,
                        url: try mediaAssetPublicURL(
                            id: $0.id,
                            slugPath: $0.slugPath,
                            filename: $0.name,
                            extension: $0.extension,
                            objectKeyGenerator: objectKeyGenerator
                        ),
                        extension: $0.extension,
                        title: $0.title,
                        altText: $0.altText,
                        variants: variantsByAsset[$0.id] ?? []
                    )
                }
            )
        }

    }
}
