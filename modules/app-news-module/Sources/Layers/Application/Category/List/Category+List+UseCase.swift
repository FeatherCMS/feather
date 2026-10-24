public import FeatherApplication
public import FeatherModuleKit
import NewsDomain
public import NewsModule

//
//  Category+List+UseCase.swift
//  app-news-module
//
//  Created by Binary Birds on 2026. 06. 18.

extension Category.List {
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

            let inputQuery = input.query

            return try await query.run { scope in
                let categories = try await scope.category.list(
                    query: inputQuery
                )
                var items: [Output.Item] = []
                items.reserveCapacity(categories.items.count)
                for item in categories.items {
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

        public func count(
            subject: Subject,
            input: Input
        ) async throws -> Int {
            let action = Action()

            guard try await authorizer.can(subject: subject, perform: action)
            else {
                throw AuthError(kind: .forbidden, message: action.key.rawValue)
            }

            let inputQuery = input.query

            return try await query.run { scope in
                try await scope.category.count(
                    query: inputQuery
                )
            }
        }
    }
}
