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
//  AddCategory.swift
//  app-news-module
//
//  Created by Binary Birds on 2026. 06. 18.

public struct AddCategory: UseCase {
    struct Action: PermissionAction {
        let key = NewsPermissions.Categories.create
    }

    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<WriteCategoryMetadata>

    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<WriteCategoryMetadata>
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
    }

    public struct Input: DTO {
        public let title: String
        public let excerpt: String
        public let content: String
        public let imageAssetId: String?
        public let metadata: PageMetadataInput

        public init(
            title: String,
            excerpt: String,
            content: String,
            imageAssetId: String?,
            metadata: PageMetadataInput
        ) {
            self.title = title
            self.excerpt = excerpt
            self.content = content
            self.imageAssetId = imageAssetId
            self.metadata = metadata
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> CategoryDetail {
        let action = Action()

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        let model = try await transaction.run { scope in
            let prefix =
                try await scope.variable.get(
                    "news.category.path_prefix"
                ) ?? "news/categories"
            let model = try await scope.category.insert(
                Category.create(
                    title: input.title,
                    excerpt: input.excerpt,
                    content: input.content,
                    imageAssetId: input.imageAssetId,
                    metadata: input.metadata.asMetadataBase(
                        template: "news.category",
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
            metadata: model.metadata.asDetail,
            createdAt: model.createdAt,
            updatedAt: model.updatedAt
        )
    }
}
