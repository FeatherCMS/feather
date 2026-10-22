public import AccountModule
public import FeatherApplication
public import FeatherModuleKit

extension Invitation.Search {
    public struct UseCase: FeatherApplication.UseCase {
        let authorizer: any Authorizer
        let query: any QueryExecutor<Invitation.Search.Scope>

        public init(
            authorizer: any Authorizer,
            query: any QueryExecutor<Invitation.Search.Scope>
        ) {
            self.authorizer = authorizer
            self.query = query
        }

        public func execute(
            subject: Subject,
            input: Invitation.Search.Input
        ) async throws -> Invitation.Search.Output {
            let action = Action()
            guard try await authorizer.can(subject: subject, perform: action)
            else {
                throw AuthError(kind: .forbidden, message: action.key.rawValue)
            }

            return try await query.run { scope in
                try await scope.query.search(query: input.query)
            }
        }
    }
}
