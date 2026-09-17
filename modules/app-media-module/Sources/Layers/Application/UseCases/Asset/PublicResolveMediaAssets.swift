import FeatherApplication
import FeatherContracts

public struct PublicResolveMediaAssets: UseCase {
    let query: any QueryExecutor<ReadMedia>

    public init(query: any QueryExecutor<ReadMedia>) {
        self.query = query
    }

    public struct Input: DTO {
        public let ids: [String]
        public let variants: [String]?

        public init(
            ids: [String],
            variants: [String]?
        ) {
            self.ids = ids
            self.variants = variants
        }
    }

    public func execute(
        input: Input
    ) async throws -> MediaAssetResolve {
        try await query.run { scope in
            try await scope.assets.resolve(
                ids: input.ids,
                variants: input.variants
            )
        }
    }
}
