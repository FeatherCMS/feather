import FeatherApplication
import FeatherContracts
import FeatherDomain
import Foundation
import NewsContracts
import NewsDomain
import SystemApplication
import WebApplication
import WebDomain

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

    public struct Input: DTO {
        public let title: String
        public let excerpt: String
        public let content: String
        public let imageAssetId: String?
        public let categoryIds: [String]
        public let metadata: PageMetadataInput

        public init(
            title: String,
            excerpt: String,
            content: String,
            imageAssetId: String?,
            categoryIds: [String],
            metadata: PageMetadataInput
        ) {
            self.title = title
            self.excerpt = excerpt
            self.content = content
            self.imageAssetId = imageAssetId
            self.categoryIds = categoryIds
            self.metadata = metadata
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> ArticleDetail {
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
