public import FeatherApplication
public import FeatherModuleKit
public import MediaModule

extension Asset.File.PublicResolve {
    public struct UseCase: FeatherApplication.UseCase {
        let query: any QueryExecutor<Asset.File.PublicResolve.Scope>

        public init(query: any QueryExecutor<Asset.File.PublicResolve.Scope>) {
            self.query = query
        }

        public func execute(
            input: Input
        ) async throws -> Output {
            try await query.run { scope in
                try await scope.query.resolvePublic(
                    ids: input.ids,
                    variants: input.variants
                )
            }
        }
    }
}
