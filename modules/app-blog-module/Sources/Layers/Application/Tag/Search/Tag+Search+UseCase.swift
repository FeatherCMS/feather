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
            let (list, total) = try await query.run { scope in
                async let list = scope.tag.list(query: input.query)
                async let total = scope.tag.count(query: input.query)
                return try await (list, total)
            }
            let items = list.items.map {
                Output.Item(
                    id: $0.id,
                    title: $0.title,
                    excerpt: $0.excerpt,
                    imageAssetId: $0.imageAssetId,
                    createdAt: $0.createdAt,
                    updatedAt: $0.updatedAt
                )
            }
            return .init(items: items, total: total)
        }
    }
}
