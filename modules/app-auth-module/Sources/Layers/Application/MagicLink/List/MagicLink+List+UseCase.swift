public import AuthModule
public import FeatherApplication
public import FeatherModuleKit

extension MagicLink.List {
    public struct UseCase: FeatherApplication.UseCase {

        let authorizer: any Authorizer
        let query: any QueryExecutor<Scope>

        public init(
            authorizer: any Authorizer,
            query: any QueryExecutor<Scope>
        ) {
            self.authorizer = authorizer
            self.query = query
        }

        public func execute(
            subject: Subject,
            input: Input
        ) async throws -> MagicLink.List.Output {
            guard
                try await authorizer.can(
                    subject: subject,
                    perform: Action()
                )
            else {
                throw AuthError(
                    kind: .forbidden,
                    message: Action().key.rawValue
                )
            }

            return try await query.run { scope in
                try await scope.magicLink.list(query: input.query)
            }
        }

        public func count(
            subject: Subject,
            input: Input
        ) async throws -> Int {
            guard
                try await authorizer.can(
                    subject: subject,
                    perform: Action()
                )
            else {
                throw AuthError(
                    kind: .forbidden,
                    message: Action().key.rawValue
                )
            }

            return try await query.run { scope in
                try await scope.magicLink.count(query: input.query)
            }
        }

    }
}
