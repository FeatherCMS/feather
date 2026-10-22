public import FeatherModuleKit
public import FeatherApplication
import WebDomain
public import WebModule

extension Settings.Public.Detail {
    public struct UseCase: FeatherApplication.UseCase {
        let query: any QueryExecutor<Scope>

        public init(
            query: any QueryExecutor<Scope>
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
