import Application
import Domain
import WebDomain
import struct Foundation.Date

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
        public let referenceType: String??
        public let referenceID: String??
        public let slug: String?
        public let publicationDate: Date??
        public let expirationDate: Date??
        public let status: Metadata.Status?
        public let title: String??
        public let excerpt: String??
        public let imageURL: String??
        public let canonicalURL: String?
        public let noIndex: Bool?
        public let primaryKeyword: String?
        public let cssCodeInjection: String?
        public let javascriptCodeInjection: String?
        public let structuredDataCodeInjection: String?

        public init(
            id: String,
            referenceType: String?? = nil,
            referenceID: String?? = nil,
            slug: String?,
            publicationDate: Date??,
            expirationDate: Date??,
            status: Metadata.Status?,
            title: String?? = nil,
            excerpt: String?? = nil,
            imageURL: String?? = nil,
            canonicalURL: String?,
            noIndex: Bool? = nil,
            primaryKeyword: String? = nil,
            cssCodeInjection: String?,
            javascriptCodeInjection: String?,
            structuredDataCodeInjection: String? = nil
        ) {
            self.id = id
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

        let model = try await transaction.run { context in
            guard var model = try await context.metadata.find(id: input.id)
            else {
                throw Error(message: "Metadata not found")
            }

            let resolvedReference: Metadata.Reference?? =
                if let referenceType = input.referenceType {
                    if let referenceType,
                        let referenceID = input.referenceID
                            ?? model.reference?.id
                    {
                        .some(.init(type: referenceType, id: referenceID))
                    }
                    else {
                        .some(nil)
                    }
                }
                else if let referenceID = input.referenceID {
                    if let referenceType = model.reference?.type,
                        let referenceID
                    {
                        .some(.init(type: referenceType, id: referenceID))
                    }
                    else {
                        .some(nil)
                    }
                }
                else {
                    nil
                }

            try model.update(
                reference: resolvedReference,
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
                structuredDataCodeInjection: input.structuredDataCodeInjection
            )

            return try await context.metadata.update(model)
        }
        return model.asDetail
    }
}
