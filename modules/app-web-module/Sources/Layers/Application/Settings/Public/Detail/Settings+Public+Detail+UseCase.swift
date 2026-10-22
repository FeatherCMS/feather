public import FeatherModuleKit
public import WebDomain

extension Settings.Public.Detail {
    public struct UseCase {
        let query: any QueryExecutor<Settings.Repository.Scope>

        public init(
            query: any QueryExecutor<Settings.Repository.Scope>
        ) {
            self.query = query
        }

        public func execute() async throws -> Settings.Detail.Output {
            try await query.run { scope in
                try await scope.settings.get().asDetail
            }
        }
    }
}
