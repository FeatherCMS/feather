import WebContracts
//
//  AddMetadata.swift
//  app-web-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherApplication
import FeatherContracts
import FeatherDomain
import WebDomain

import struct Foundation.Date

public struct AddMetadata: UseCase {

    struct Action: PermissionAction {
        let key = WebPermissions.Metadata.create
    }

    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<WriteMetadata>

    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<WriteMetadata>
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
    }

    public struct Input: DTO {
        public let referenceType: String
        public let referenceID: String
        public let template: String
        public let slug: String
        public let publicationDate: Date
        public let expirationDate: Date?
        public let status: Metadata.Status
        public let title: String?
        public let excerpt: String?
        public let imageURL: String?
        public let canonicalURL: String?
        public let noIndex: Bool
        public let primaryKeyword: String
        public let cssCodeInjection: String?
        public let javascriptCodeInjection: String?
        public let structuredDataCodeInjection: String?

        public init(
            referenceType: String,
            referenceID: String,
            slug: String,
            template: String,
            publicationDate: Date,
            expirationDate: Date?,
            status: Metadata.Status,
            title: String?,
            excerpt: String?,
            imageURL: String?,
            canonicalURL: String?,
            noIndex: Bool,
            primaryKeyword: String,
            cssCodeInjection: String?,
            javascriptCodeInjection: String?,
            structuredDataCodeInjection: String?
        ) {
            self.referenceType = referenceType
            self.referenceID = referenceID
            self.template = template
            self.slug = slug
            self.publicationDate = publicationDate
            self.expirationDate = expirationDate
            self.status = status
            self.title = title
            self.excerpt = excerpt
            self.imageURL = imageURL
            self.canonicalURL = canonicalURL
            self.noIndex = noIndex
            self.primaryKeyword = primaryKeyword
            self.cssCodeInjection = cssCodeInjection
            self.javascriptCodeInjection = javascriptCodeInjection
            self.structuredDataCodeInjection = structuredDataCodeInjection
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> MetadataDetail {
        let action = Action()

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        let reference: Metadata.Reference = .existing(
            .init(type: input.referenceType, id: input.referenceID)
        )

        let model = try await transaction.run { scope in
            try await scope.metadata.insert(
                Metadata.create(
                    reference: reference,
                    template: input.template,
                    slug: input.slug,
                    publicationDate: input.publicationDate,
                    expirationDate: input.expirationDate,
                    status: input.status,
                    title: input.title,
                    excerpt: input.excerpt,
                    imageURL: input.imageURL,
                    canonicalURL: input.canonicalURL,
                    noIndex: input.noIndex,
                    primaryKeyword: input.primaryKeyword,
                    cssCodeInjection: input.cssCodeInjection,
                    javascriptCodeInjection: input.javascriptCodeInjection,
                    structuredDataCodeInjection: input
                        .structuredDataCodeInjection
                )
            )
        }
        return model.asDetail
    }
}
