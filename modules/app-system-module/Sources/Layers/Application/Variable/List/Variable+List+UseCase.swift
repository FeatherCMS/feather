public import FeatherApplication
public import FeatherModuleKit
public import SystemModule

extension Variable.List {
    public struct UseCase: FeatherApplication.UseCase {
        let authorizer: any Authorizer
        let query: any QueryExecutor<Scope>

        public init(authorizer: any Authorizer, query: any QueryExecutor<Scope>)
        {
            self.authorizer = authorizer
            self.query = query
        }

        public func execute(subject: Subject, input: Input) async throws
            -> Output
        {
            let action = Action()
            guard try await authorizer.can(subject: subject, perform: action)
            else {
                throw AuthError(kind: .forbidden, message: action.key.rawValue)
            }
            let queryInput = input.query
            return try await query.run { scope in
                try await scope.variable.list(query: queryInput)
            }
        }

        public func count(subject: Subject, input: Input) async throws -> Int {
            let action = Action()
            guard try await authorizer.can(subject: subject, perform: action)
            else {
                throw AuthError(kind: .forbidden, message: action.key.rawValue)
            }
            let queryInput = input.query
            return try await query.run { scope in
                try await scope.variable.count(query: queryInput)
            }
        }
    }
}
