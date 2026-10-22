public import FeatherApplication
public import FeatherModuleKit
public import NewsModule
import NewsDomain
import WebApplication
import WebDomain

//
//  EditArticle.swift
//  app-news-module
//
//  Created by Binary Birds on 2026. 06. 18.

public struct EditArticle: UseCase {
    struct Action: PermissionAction {
        let key = Article.Permissions.update
    }

    struct Error: UseCaseError {
        let message: String
    }

    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<WriteArticleMetadata>

    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<WriteArticleMetadata>
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
    }

    public func execute(
        subject: Subject,
        input: Article.Edit.Input
    ) async throws -> Article.Detail.Output {
        let action = Action()

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        let model = try await transaction.run { scope in
            guard var model = try await scope.article.find(id: input.id)
            else {
                throw Error(message: "Article not found")
            }
            try model.update(
                title: input.title,
                excerpt: input.excerpt,
                content: input.content,
                imageAssetId: input.imageAssetId,
                categoryIds: input.categoryIds
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

            return try await scope.article.update(model)
        }
        return .init(
            id: model.id,
            title: model.title,
            excerpt: model.excerpt,
            content: model.content,
            imageAssetId: model.imageAssetId,
            categoryIds: model.categoryIds,
            metadata: model.metadata.asDetail,
            createdAt: model.createdAt,
            updatedAt: model.updatedAt
        )
    }
}
