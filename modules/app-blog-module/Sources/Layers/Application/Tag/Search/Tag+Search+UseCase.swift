public import BlogModule
public import FeatherApplication
public import FeatherModuleKit

extension Tag.Search {
    public struct UseCase: FeatherApplication.UseCase {
        let authorizer: any Authorizer
        let query: any QueryExecutor<Tag.Search.Scope>

        public init(
            authorizer: any Authorizer,
            query: any QueryExecutor<Tag.Search.Scope>
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
                try await scope.tag.search(query: input.query)
            }
        }
    }
}
