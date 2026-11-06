public import FeatherApplication
public import FeatherModuleKit
public import MediaModule

extension Variant.Processor.List {
    public struct UseCase: FeatherApplication.UseCase {
        let query: any QueryExecutor<Scope>

        public init(query: any QueryExecutor<Scope>) {
            self.query = query
        }

        public func execute() async throws -> Output {
            try await query.run { scope in
                try await scope.query.list()
            }
        }
    }
}
