public import FeatherDomain
public import FeatherInfrastructure
public import MediaApplication
public import MediaModule

extension Asset.File.PublicResolve.Query {
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

        public func resolvePublic(
            ids: [String],
            variants: [String]?
        ) async throws -> Asset.File.PublicResolve.Output {
            let output = try await Asset.File.Resolve.Query
                .Database(
                    context: context,
                    objectKeyGenerator: objectKeyGenerator
                )
                .resolve(ids: ids, variants: variants)
            return .init(
                items: output.items.map { item in
                    .init(
                        id: item.id,
                        url: item.url,
                        variants: item.variants.map {
                            .init(key: $0.key, url: $0.url)
                        }
                    )
                }
            )
        }
    }
}
