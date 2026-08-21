import FeatherApplication
import FeatherContracts
import FeatherDomain
import NewsContracts
import NewsDomain
import WebApplication
import WebDomain

//
//  EditCategory.swift
//  app-news-module
//
//  Created by Binary Birds on 2026. 06. 18.

public struct EditCategory: UseCase {
    struct Action: PermissionAction {
        let key = NewsPermissions.Categories.update
    }

    struct Error: UseCaseError {
        let message: String
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
        public let id: String
        public let title: String?
        public let excerpt: String?
        public let content: String?
        public let imageAssetId: String??
        public let metadata: PageMetadataInput?

        public init(
            id: String,
            title: String?,
            excerpt: String?,
            content: String?,
            imageAssetId: String??,
            metadata: PageMetadataInput?
        ) {
            self.id = id
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
            metadata: model.metadata.asDetail,
            createdAt: model.createdAt,
            updatedAt: model.updatedAt
        )
    }
}
