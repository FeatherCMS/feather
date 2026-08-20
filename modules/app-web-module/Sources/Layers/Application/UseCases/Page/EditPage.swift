import WebContracts
//
//  EditPage.swift
//  app-web-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherApplication
import FeatherContracts
import FeatherDomain
import WebDomain

public struct EditPage: UseCase {

    struct Action: PermissionAction {
        let key = WebPermissions.Pages.update
    }

    struct Error: UseCaseError {
        let message: String
    }

    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<WritePageMetadata>

    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<WritePageMetadata>
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
    }

    public struct Input: DTO {
        public let id: String
        public let title: String?
        public let excerpt: String?
        public let content: String?
        public let imageAssetId: String?
        public let metadata: PageMetadataInput?

        public init(
            id: String,
            title: String?,
            excerpt: String?,
            content: String?,
            imageAssetId: String?,
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
    ) async throws -> PageDetail {
        let action = Action()

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        let (model, metadata) = try await transaction.run { scope in
            guard var model = try await scope.page.find(id: input.id) else {
                throw Error(message: "Page not found")
            }
            guard
                var metadata = try await scope.metadata.find(
                    reference: .existing(.init(type: "web.page", id: input.id))
                )
            else {
                throw Error(message: "Page metadata not found")
            }

            try model.update(
                title: input.title,
                excerpt: input.excerpt,
                content: input.content,
                imageAssetId: input.imageAssetId
            )
            if let metadataInput = input.metadata {
                try metadata.update(
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

            let savedModel = try await scope.page.update(model)
            let savedMetadata = try await scope.metadata.update(metadata)
            return (savedModel, savedMetadata)
        }
        return .init(
            id: model.id,
            title: model.title,
            excerpt: model.excerpt,
            content: model.content,
            imageAssetId: model.imageAssetId,
            metadata: metadata.asDetail,
            createdAt: model.createdAt,
            updatedAt: model.updatedAt
        )
    }
}
