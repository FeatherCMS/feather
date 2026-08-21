import FeatherApplication
import FeatherContracts
import FeatherDomain
import WebContracts
import WebDomain

import struct Foundation.Date

//
//  EditMetadata.swift
//  app-web-module
//
//  Created by Binary Birds on 2026. 06. 18.

public struct EditMetadata: UseCase {

    struct Action: PermissionAction {
        let key = WebPermissions.Metadata.update
    }

    struct Error: UseCaseError {
        let message: String
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
        public let id: String
        public let template: String?
        public let slug: String?
        public let publicationDate: Date?
        public let expirationDate: Date?
        public let status: Metadata.Status?
        public let title: String?
        public let excerpt: String?
        public let imageURL: String?
        public let canonicalURL: String?
        public let noIndex: Bool?
        public let primaryKeyword: String?
        public let cssCodeInjection: String?
        public let javascriptCodeInjection: String?
        public let structuredDataCodeInjection: String?

        public init(
            id: String,
            template: String? = nil,
            slug: String?,
            publicationDate: Date?,
            expirationDate: Date?,
            status: Metadata.Status?,
            title: String? = nil,
            excerpt: String? = nil,
            imageURL: String? = nil,
            canonicalURL: String?,
            noIndex: Bool? = nil,
            primaryKeyword: String? = nil,
            cssCodeInjection: String?,
            javascriptCodeInjection: String?,
            structuredDataCodeInjection: String? = nil
        ) {
            self.id = id
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

        let model = try await transaction.run { scope in
            guard var model = try await scope.metadata.find(id: input.id)
            else {
                throw Error(message: "Metadata not found")
            }

            try model.update(
                template: input.template,
                slug: input.slug,
                publicationDate: input.publicationDate.flatMap { $0 },
                expirationDate: input.expirationDate.flatMap { $0 },
                status: input.status,
                title: input.title.flatMap { $0 },
                excerpt: input.excerpt.flatMap { $0 },
                imageURL: input.imageURL.flatMap { $0 },
                canonicalURL: input.canonicalURL,
                noIndex: input.noIndex,
                primaryKeyword: input.primaryKeyword,
                cssCodeInjection: input.cssCodeInjection,
                javascriptCodeInjection: input.javascriptCodeInjection,
                structuredDataCodeInjection: input.structuredDataCodeInjection
            )

            return try await scope.metadata.update(model)
        }
        return model.asDetail
    }
}
