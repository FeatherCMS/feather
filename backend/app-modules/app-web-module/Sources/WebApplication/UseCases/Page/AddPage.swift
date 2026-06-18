import Application
import Domain
import Foundation
import WebApplication
import WebDomain

public struct AddPage: UseCase {

    struct Action: PermissionAction {
        let key = WebPermissions.Pages.create
    }

    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<WritePageMetadata>
    let idGenerator: any IDGenerator

    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<WritePageMetadata>,
        idGenerator: any IDGenerator
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
        self.idGenerator = idGenerator
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

        let pageID = idGenerator.generate()
        let metadataID = idGenerator.generate()

        let (model, metadata) = try await transaction.run { context in
            let slug = input.metadata.slug
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .trimmingCharacters(in: CharacterSet(charactersIn: "/"))
            let model = try await context.page.insert(
                Page.create(
                    id: pageID,
                    title: input.title,
                    excerpt: input.excerpt,
                    content: input.content,
                    imageAssetId: input.imageAssetId
                )
            )
            let metadata = try await context.metadata.insert(
                Metadata.create(
                    id: metadataID,
                    reference: .init(
                        type: "web.page",
                        id: model.id
                    ),
                    slug: slug,
                    publicationDate: input.metadata.publicationDate,
                    expirationDate: input.metadata.expirationDate,
                    status: input.metadata.status,
                    title: input.metadata.title,
                    excerpt: input.metadata.excerpt,
                    imageURL: input.metadata.imageURL,
                    canonicalURL: input.metadata.canonicalURL,
                    noIndex: input.metadata.noIndex,
                    primaryKeyword: input.metadata.primaryKeyword,
                    cssCodeInjection: input.metadata.cssCodeInjection,
                    javascriptCodeInjection: input.metadata
                        .javascriptCodeInjection,
                    structuredDataCodeInjection: input.metadata
                        .structuredDataCodeInjection
                )
            )
            return (model, metadata)
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
