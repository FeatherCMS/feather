public import FeatherApplication
public import FeatherModuleKit
import NewsContracts
public import NewsDomain
import SystemApplication
import WebApplication

//
//  AddArticle.swift
//  app-news-module
//
//  Created by Binary Birds on 2026. 06. 18.

public struct AddArticle: UseCase {
    struct Action: PermissionAction {
        let key = NewsPermissions.Articles.create
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
        input: Article.Add.Input
    ) async throws -> Article.Detail.Output {
        let action = Action()

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        let model = try await transaction.run { scope in
            let prefix =
                try await scope.variable.get(
                    "news.article.path_prefix"
                ) ?? "news"
            let model = try await scope.article.insert(
                Article.create(
                    title: input.title,
                    excerpt: input.excerpt,
                    content: input.content,
                    imageAssetId: input.imageAssetId,
                    categoryIds: input.categoryIds,
                    metadata: input.metadata.asMetadataBase(
                        template: "news.article",
                        slug: input.metadata.slug.prefixedSlug(with: prefix)
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
            categoryIds: model.categoryIds,
            metadata: model.metadata.asDetail,
            createdAt: model.createdAt,
            updatedAt: model.updatedAt
        )
    }
}
