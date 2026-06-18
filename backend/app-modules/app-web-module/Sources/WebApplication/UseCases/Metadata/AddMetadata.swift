import Domain
import Application
import WebDomain
import struct Foundation.Date

public struct AddMetadata: UseCase {

    struct Action: PermissionAction {
        let key = WebPermissions.Metadata.create
    }

    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<WriteMetadata>
    let idGenerator: any IDGenerator

    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<WriteMetadata>,
        idGenerator: any IDGenerator
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
        self.idGenerator = idGenerator
    }

    public struct Input: DTO {
        public let referenceType: String?
        public let referenceID: String?
        public let slug: String
        public let publicationDate: Date?
        public let expirationDate: Date?
        public let status: Metadata.Status
        public let title: String?
        public let excerpt: String?
        public let imageURL: String?
        public let canonicalURL: String
        public let noIndex: Bool
        public let primaryKeyword: String
        public let cssCodeInjection: String
        public let javascriptCodeInjection: String
        public let structuredDataCodeInjection: String

        public init(
            referenceType: String? = nil,
            referenceID: String? = nil,
            slug: String,
            publicationDate: Date?,
            expirationDate: Date?,
            status: Metadata.Status,
            title: String?,
            excerpt: String?,
            imageURL: String?,
            canonicalURL: String,
            noIndex: Bool,
            primaryKeyword: String,
            cssCodeInjection: String,
            javascriptCodeInjection: String,
            structuredDataCodeInjection: String
        ) {
            self.referenceType = referenceType
            self.referenceID = referenceID
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

        let reference: Metadata.Reference? =
            if let referenceType = input.referenceType,
                let referenceID = input.referenceID
            {
                .init(type: referenceType, id: referenceID)
            }
            else {
                nil
            }

        let model = try await transaction.run { context in
            try await context.metadata.insert(
                Metadata.create(
                    id: idGenerator.generate(),
                    reference: reference,
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
