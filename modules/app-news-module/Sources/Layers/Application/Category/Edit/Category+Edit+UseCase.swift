public import FeatherApplication
public import FeatherModuleKit
import NewsDomain
public import NewsModule
import WebApplication
import WebDomain

//
//  Category.Edit.UseCase.swift
//  app-news-module
//
//  Created by Binary Birds on 2026. 06. 18.

extension Category.Edit {
    public struct UseCase: FeatherApplication.UseCase {
        let authorizer: any Authorizer
        let transaction: any TransactionExecutor<Category.Edit.Scope>

        public init(
            authorizer: any Authorizer,
            transaction: any TransactionExecutor<Category.Edit.Scope>
        ) {
            self.authorizer = authorizer
            self.transaction = transaction
        }

        public func execute(
            subject: Subject,
            input: Category.Edit.Input
        ) async throws -> Output {
            let action = Action()

            guard try await authorizer.can(subject: subject, perform: action)
            else {
                throw AuthError(kind: .forbidden, message: action.key.rawValue)
            }

            let model = try await transaction.run { scope in
                guard var model = try await scope.category.find(id: input.id)
                else {
                    throw Error(message: "Category not found")
                }
                try model.update(
                    title: input.title,
                    excerpt: input.excerpt,
                    content: input.content,
                    imageAssetId: input.imageAssetId
                )
                if let metadataInput = input.metadata {
                    try model.metadata.update(
                        template: metadataInput.template,
                        slug: metadataInput.slug,
                        publicationDate: metadataInput.publicationDate,
                        expirationDate: metadataInput.expirationDate,
                        status: metadataInput.status,
                        title: metadataInput.title,
                        excerpt: metadataInput.excerpt,
                        imageURL: metadataInput.imageURL,
                        canonicalURL: metadataInput.canonicalURL,
                        noIndex: metadataInput.noIndex,
                        primaryKeyword: metadataInput.primaryKeyword,
                        cssCodeInjection: metadataInput.cssCodeInjection,
                        javascriptCodeInjection: metadataInput
                            .javascriptCodeInjection,
                        structuredDataCodeInjection: metadataInput
                            .structuredDataCodeInjection
                    )
                }

                return try await scope.category.update(model)
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
