import Application
import BlogDomain
import Domain
import WebApplication
import WebDomain

public struct EditTag: UseCase {

    struct Action: PermissionAction {
        let key = BlogPermissions.Tags.update
    }

    struct Error: UseCaseError {
        let message: String
    }

    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<WriteTagMetadata>

    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<WriteTagMetadata>
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
        public let metadata: BlogMetadataInput?

        public init(
            id: String,
            title: String?,
            excerpt: String?,
            content: String?,
            imageAssetId: String??,
            metadata: BlogMetadataInput?
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
    ) async throws -> TagDetail {
        let action = Action()

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        let (model, metadata) = try await transaction.run { context in
            guard var model = try await context.tag.find(id: input.id) else {
                throw Error(message: "Tag not found")
            }
            guard
                var metadata = try await context.metadata.find(
                    reference: .init(type: "blog.tag", id: input.id)
                )
            else {
                throw Error(message: "Tag metadata not found")
            }

            try model.update(
                title: input.title,
                excerpt: input.excerpt,
                content: input.content,
                imageAssetId: input.imageAssetId
            )
            if let metadataInput = input.metadata {
                try metadata.update(
                    slug: metadataInput.slug,
                    publicationDate: .some(metadataInput.publicationDate),
                    expirationDate: .some(metadataInput.expirationDate),
                    status: metadataInput.status,
                    title: .some(metadataInput.title),
                    excerpt: .some(metadataInput.excerpt),
                    imageURL: .some(metadataInput.imageURL),
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

            let savedModel = try await context.tag.update(model)
            let savedMetadata = try await context.metadata.update(metadata)
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
