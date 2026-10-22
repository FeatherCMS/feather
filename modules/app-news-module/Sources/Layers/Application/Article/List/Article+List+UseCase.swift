public import FeatherApplication
public import FeatherModuleKit
import NewsDomain
public import NewsModule

//
//  Article.List.UseCase.swift
//  app-news-module
//
//  Created by Binary Birds on 2026. 07. 06.

extension Article.List {
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
            input: Article.List.Input
        ) async throws -> Article.List.Output {
            let action = Action()

            guard try await authorizer.can(subject: subject, perform: action)
            else {
                throw AuthError(kind: .forbidden, message: action.key.rawValue)
            }

            let inputQuery = input.query

            return try await query.run { scope in
                let articles = try await scope.article.list(query: inputQuery)
                var items: [Article.List.Output.Item] = []
                items.reserveCapacity(articles.items.count)
                for item in articles.items {
                    items.append(
                        .init(
                            id: item.id,
                            title: item.title,
                            excerpt: item.excerpt,
                            content: item.content,
                            imageAssetId: item.imageAssetId,
                            createdAt: item.createdAt,
                            updatedAt: item.updatedAt
                        )
                    )
                }
                return .init(items: items)
            }
        }

        public func count(
            subject: Subject,
            input: Article.List.Input
        ) async throws -> Int {
            let action = Action()

            guard try await authorizer.can(subject: subject, perform: action)
            else {
                throw AuthError(kind: .forbidden, message: action.key.rawValue)
            }

            let inputQuery = input.query

            return try await query.run { scope in
                try await scope.article.count(
                    query: inputQuery
                )
            }
        }
    }
}
