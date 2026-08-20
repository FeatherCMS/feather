import WebContracts
//
//  AddPage.swift
//  app-web-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherApplication
import FeatherContracts
import FeatherDomain
import Foundation
import WebDomain

public struct AddPage: UseCase {

    struct Action: PermissionAction {
        let key = WebPermissions.Pages.create
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
    ) async throws -> PageDetail {
        let action = Action()

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        let model = try await transaction.run { scope in
            let model = try await scope.page.insert(
                Page.create(
                    title: input.title,
                    excerpt: input.excerpt,
                    content: input.content,
                    imageAssetId: input.imageAssetId,
                    metadata: input.metadata.asMetadataBase(
                        template: input.metadata.template,
                        slug: input.metadata.slug
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
