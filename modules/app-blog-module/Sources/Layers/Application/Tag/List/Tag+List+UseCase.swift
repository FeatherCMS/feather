public import BlogModule
public import FeatherApplication
public import FeatherModuleKit

//
//  ListTags.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 06. 18.

extension Tag.List {
    public struct UseCase: FeatherApplication.UseCase {
        let authorizer: any Authorizer
        let query: any QueryExecutor<Tag.List.Scope>

        public init(
            authorizer: any Authorizer,
            query: any QueryExecutor<Tag.List.Scope>
        ) {
            self.authorizer = authorizer
            self.query = query
        }

        public func execute(
            subject: Subject,
            input: Input
        ) async throws -> Tag.List.Output {
            let action = Action()

            guard try await authorizer.can(subject: subject, perform: action)
            else {
                throw AuthError(kind: .forbidden, message: action.key.rawValue)
            }

            return try await query.run { scope in
                let tags = try await scope.tag.list(query: .init())
                var items: [Tag.List.Output.Item] = []
                items.reserveCapacity(tags.items.count)
                for item in tags.items {
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
