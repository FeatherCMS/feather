public import BlogModule
public import FeatherApplication
public import FeatherModuleKit

//
//  ListPosts.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 07. 06.

extension Post.List {
    public struct UseCase: FeatherApplication.UseCase {
        let authorizer: any Authorizer
        let query: any QueryExecutor<Post.List.Scope>

        public init(
            authorizer: any Authorizer,
            query: any QueryExecutor<Post.List.Scope>
        ) {
            self.authorizer = authorizer
            self.query = query
        }

        public func execute(
            subject: Subject,
            input: Input
        ) async throws -> Post.List.Output {
            let action = Action()

            guard try await authorizer.can(subject: subject, perform: action)
            else {
                throw AuthError(kind: .forbidden, message: action.key.rawValue)
            }

            return try await query.run { scope in
                let posts = try await scope.post.list(query: .init())
                var items: [Post.List.Output.Item] = []
                items.reserveCapacity(posts.items.count)
                for item in posts.items {
                    items.append(
                        .init(
                            id: item.id,
                            title: item.title,
                            excerpt: item.excerpt,
                            imageAssetId: item.imageAssetId,
                            createdAt: item.createdAt,
                            updatedAt: item.updatedAt
                        )
                    )
                }
                return .init(items: items)
            }
        }
    }
}
