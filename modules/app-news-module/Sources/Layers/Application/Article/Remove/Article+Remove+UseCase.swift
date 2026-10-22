public import FeatherApplication
public import FeatherModuleKit
import NewsDomain
public import NewsModule
import WebDomain

//
//  Article.Remove.UseCase.swift
//  app-news-module
//
//  Created by Binary Birds on 2026. 06. 18.

extension Article.Remove {
    public struct UseCase: FeatherApplication.UseCase {
        let authorizer: any Authorizer
        let transaction: any TransactionExecutor<Article.Remove.Scope>

        public init(
            authorizer: any Authorizer,
            transaction: any TransactionExecutor<Article.Remove.Scope>
        ) {
            self.authorizer = authorizer
            self.transaction = transaction
        }

        public func execute(
            subject: Subject,
            input: Article.Remove.Input
        ) async throws -> [String] {
            let action = Action()

            guard try await authorizer.can(subject: subject, perform: action)
            else {
                throw AuthError(kind: .forbidden, message: action.key.rawValue)
            }

            return try await transaction.run { scope in
                _ = try await scope.metadata.delete(
                    referenceType: "news.article",
                    referenceIds: input.ids
                )
                return try await scope.article.delete(ids: input.ids)
            }
        }
    }
}
