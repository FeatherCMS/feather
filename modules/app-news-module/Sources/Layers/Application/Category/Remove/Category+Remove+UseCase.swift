public import FeatherApplication
public import FeatherModuleKit
import NewsDomain
public import NewsModule
import WebDomain

//
//  Category.Remove.UseCase.swift
//  app-news-module
//
//  Created by Binary Birds on 2026. 06. 18.

extension Category.Remove {
    public struct UseCase: FeatherApplication.UseCase {
        let authorizer: any Authorizer
        let transaction: any TransactionExecutor<Category.Remove.Scope>

        public init(
            authorizer: any Authorizer,
            transaction: any TransactionExecutor<Category.Remove.Scope>
        ) {
            self.authorizer = authorizer
            self.transaction = transaction
        }

        public func execute(
            subject: Subject,
            input: Category.Remove.Input
        ) async throws -> [String] {
            let action = Action()

            guard try await authorizer.can(subject: subject, perform: action)
            else {
                throw AuthError(kind: .forbidden, message: action.key.rawValue)
            }

            return try await transaction.run { scope in
                var deletedIds: [String] = []
                for id in input.ids {
                    try await scope.article.removeCategory(id: id)
                }
                _ = try await scope.metadata.delete(
                    referenceType: "news.category",
                    referenceIds: input.ids
                )
                deletedIds = try await scope.category.delete(ids: input.ids)
                return deletedIds
            }
        }
    }
}
