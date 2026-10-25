public import FeatherApplication
public import FeatherModuleKit
public import RedirectModule

extension Rule.Resolve {
    public struct UseCase: FeatherApplication.UseCase {
        let query: any QueryExecutor<Scope>

        public init(query: any QueryExecutor<Scope>) {
            self.query = query
        }

        public func execute(input: Input) async throws -> Output {
            try await query.run { scope in
                guard
                    let output = try await scope.query.resolve(
                        source: input.source
                    )
                else {
                    throw Error.notFound
                }
                return output
            }
        }
    }
}
