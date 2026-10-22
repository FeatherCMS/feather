public import BlogModule
public import FeatherApplication
public import FeatherModuleKit

extension AuthorLink.Search {
    public struct UseCase: FeatherApplication.UseCase {
        let authorizer: any Authorizer
        let query: any QueryExecutor<AuthorLink.Search.Scope>

        public init(
            authorizer: any Authorizer,
            query: any QueryExecutor<AuthorLink.Search.Scope>
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
            let (list, total) = try await query.run { scope in
                async let list = scope.authorLink.list(
                    authorId: input.authorId,
                    query: input.query
                )
                async let total = scope.authorLink.count(
                    authorId: input.authorId,
                    query: input.query
                )
                return try await (list, total)
            }
            let items = list.items.map {
                Output.Item(
                    id: $0.id,
                    authorId: $0.authorId,
                    label: $0.label,
                    url: $0.url,
                    priority: $0.priority,
                    isBlank: $0.isBlank,
                    permission: $0.permission,
                    createdAt: $0.createdAt,
                    updatedAt: $0.updatedAt
                )
            }
            return .init(items: items, total: total)
        }
    }
}
