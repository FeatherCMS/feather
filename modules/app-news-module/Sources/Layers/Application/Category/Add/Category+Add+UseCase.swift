public import FeatherApplication
public import FeatherModuleKit
import NewsDomain
public import NewsModule
import SystemApplication
import WebApplication
import WebDomain

//
//  Category+Add+UseCase.swift
//  app-news-module
//
//  Created by Binary Birds on 2026. 06. 18.

extension Category.Add {
    public struct UseCase: FeatherApplication.UseCase {
        let authorizer: any Authorizer
        let transaction: any TransactionExecutor<Scope>

        public init(
            authorizer: any Authorizer,
            transaction: any TransactionExecutor<Scope>
        ) {
            self.authorizer = authorizer
            self.transaction = transaction
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

            let model = try await transaction.run { scope in
                let prefix =
                    try await scope.variable.get(
                        "news.category.path_prefix"
                    ) ?? "news/categories"
                let model = try await scope.category.insert(
                    Category.Model.create(
                        title: input.title,
                        excerpt: input.excerpt,
                        content: input.content,
                        imageAssetId: input.imageAssetId,
                        metadata: .init(
                            template: "news.category",
                            slug: input.metadata.slug.prefixedSlug(
                                with: prefix
                            ),
                            publicationDate: input.metadata.publicationDate,
                            expirationDate: input.metadata.expirationDate,
                            status: input.metadata.status,
                            title: input.metadata.title,
                            excerpt: input.metadata.excerpt,
                            imageURL: input.metadata.imageURL,
                            canonicalURL: input.metadata.canonicalURL,
                            noIndex: input.metadata.noIndex,
                            primaryKeyword: input.metadata.primaryKeyword,
                            cssCodeInjection: input.metadata.cssCodeInjection,
                            javascriptCodeInjection: input.metadata
                                .javascriptCodeInjection,
                            structuredDataCodeInjection: input.metadata
                                .structuredDataCodeInjection
                        )
                    )
                )
                return model
            }
            return .init(
                id: model.id,
                title: model.title,
                excerpt: model.excerpt,
                content: model.content,
                imageAssetId: model.imageAssetId,
                metadata: model.metadata.asSnapshot,
                createdAt: model.createdAt,
                updatedAt: model.updatedAt
            )
        }
    }
}
