import Application
import BlogDomain
import Domain
import WebApplication
import WebDomain

public struct EditAuthor: UseCase {

    struct Action: PermissionAction {
        let key = BlogPermissions.Authors.update
    }

    struct Error: UseCaseError {
        let message: String
    }

    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<WriteAuthorMetadata>

    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<WriteAuthorMetadata>
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
    }

    public struct Input: DTO {
        public let id: String
        public let name: String?
        public let excerpt: String?
        public let content: String?
        public let profileImageAssetId: String??
        public let metadata: BlogMetadataInput?

        public init(
            id: String,
            name: String?,
            excerpt: String?,
            content: String?,
            profileImageAssetId: String??,
            metadata: BlogMetadataInput?
        ) {
            self.id = id
            self.name = name
            self.excerpt = excerpt
            self.content = content
            self.profileImageAssetId = profileImageAssetId
            self.metadata = metadata
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> AuthorDetail {
        let action = Action()

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        let (model, metadata) = try await transaction.run { context in
            guard var model = try await context.author.find(id: input.id) else {
                throw Error(message: "Author not found")
            }
            guard
                var metadata = try await context.metadata.find(
                    reference: .init(type: "blog.author", id: input.id)
                )
            else {
                throw Error(message: "Author metadata not found")
            }

            try model.update(
                name: input.name,
                excerpt: input.excerpt,
                content: input.content,
                profileImageAssetId: input.profileImageAssetId
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

            let savedModel = try await context.author.update(model)
            let savedMetadata = try await context.metadata.update(metadata)
            return (savedModel, savedMetadata)
        }
        return .init(
            id: model.id,
            name: model.name,
            excerpt: model.excerpt,
            content: model.content,
            profileImageAssetId: model.profileImageAssetId,
            metadata: metadata.asDetail,
            createdAt: model.createdAt,
            updatedAt: model.updatedAt
        )
    }
}
