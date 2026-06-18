import Application
import BlogDomain
import Domain
import Foundation
import WebApplication
import WebDomain
import SystemApplication

public struct AddTag: UseCase {

    struct Action: PermissionAction {
        let key = BlogPermissions.Tags.create
    }

    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<WriteTagMetadata>
    let idGenerator: any IDGenerator

    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<WriteTagMetadata>,
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
        public let metadata: BlogMetadataInput

        public init(
            title: String,
            excerpt: String,
            content: String,
            imageAssetId: String?,
            metadata: BlogMetadataInput
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
    ) async throws -> TagDetail {
        let action = Action()

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        let tagID = idGenerator.generate()
        let metadataID = idGenerator.generate()

        let (model, metadata) = try await transaction.run { context in
            let slug = try await metadataSlug(
                input.metadata.slug,
                variable: context.variable,
                key: "blog.tag.path_prefix",
                default: "tags"
            )
            let model = try await context.tag.insert(
                Tag.create(
                    id: tagID,
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
                        type: "blog.tag",
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

private extension AddTag {
    func metadataSlug(
        _ slug: String,
        variable: any VariableQueries,
        key: String,
        default defaultPrefix: String
    ) async throws -> String {
        let normalizedSlug = normalize(slug)
        let items = try await variable.list(
            query: .init(
                page: .init(size: 10, number: 1),
                search: key
            )
        )
        let prefix = normalize(
            items.items.first { $0.name == key }?.value ?? defaultPrefix
        )

        guard !prefix.isEmpty else {
            return normalizedSlug
        }
        guard normalizedSlug != prefix, !normalizedSlug.hasPrefix("\(prefix)/")
        else {
            return normalizedSlug
        }
        return "\(prefix)/\(normalizedSlug)"
    }

    func normalize(
        _ value: String
    ) -> String {
        value
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .trimmingCharacters(in: CharacterSet(charactersIn: "/"))
    }
}
