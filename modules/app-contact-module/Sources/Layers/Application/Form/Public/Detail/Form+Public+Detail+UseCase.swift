public import ContactModule
public import FeatherApplication
public import FeatherModuleKit

extension Form.Public.Detail {
    public struct UseCase: FeatherApplication.UseCase {
        let query: any QueryExecutor<Scope>

        public init(query: any QueryExecutor<Scope>) {
            self.query = query
        }

        public func execute(input: Input) async throws -> Output {
            try await query.run { scope in
                try await scope.form.find(key: input.key)
            }
        }
    }
}
