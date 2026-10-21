public import AuthModule
public import FeatherApplication
public import FeatherModuleKit

extension Credential.List {
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
        ) async throws -> Output {
            let action = Action()

            guard try await authorizer.can(subject: subject, perform: action)
            else {
                throw AuthError(kind: .forbidden, message: action.key.rawValue)
            }

            return try await query.run { scope in
                if let userId = input.userId {
                    return try await scope.credential.list(
                        userId: userId,
                        query: input.query
                    )
                }
                return try await scope.credential.list(query: input.query)
            }
        }

        public func count(
            subject: Subject,
            input: Input
        ) async throws -> Int {
            let action = Action()

            guard try await authorizer.can(subject: subject, perform: action)
            else {
                throw AuthError(kind: .forbidden, message: action.key.rawValue)
            }

            return try await query.run { scope in
                if let userId = input.userId {
                    return try await scope.credential.count(
                        userId: userId,
                        query: input.query
                    )
                }
                return try await scope.credential.count(query: input.query)
            }
        }

    }
}
