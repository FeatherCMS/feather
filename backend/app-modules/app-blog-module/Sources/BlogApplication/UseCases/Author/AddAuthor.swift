import Application
import BlogDomain
import Domain
import Foundation
import WebApplication
import WebDomain
import SystemApplication

public struct AddAuthor: UseCase {

    struct Action: PermissionAction {
        let key = BlogPermissions.Authors.create
    }

    struct Error: UseCaseError {
        let message: String
    }

    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<WriteAuthorMetadata>
    let idGenerator: any IDGenerator

    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<WriteAuthorMetadata>,
        idGenerator: any IDGenerator
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
        self.idGenerator = idGenerator
    }

    public struct Input: DTO {
        public let name: String
        public let excerpt: String
        public let content: String
        public let profileImageAssetId: String?
        public let metadata: BlogMetadataInput

        public init(
            name: String,
            excerpt: String,
            content: String,
            profileImageAssetId: String?,
            metadata: BlogMetadataInput
        ) {
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

        let authorID = idGenerator.generate()
        let metadataID = idGenerator.generate()

        let (model, metadata) = try await transaction.run { context in
            let slug = try await metadataSlug(
                input.metadata.slug,
                variable: context.variable,
                key: "blog.author.path_prefix",
                default: "authors"
            )
            let model = try await context.author.insert(
                Author.create(
                    id: authorID,
                    name: input.name,
                    excerpt: input.excerpt,
                    content: input.content,
                    profileImageAssetId: input.profileImageAssetId
                )
            )
            let metadata = try await context.metadata.insert(
                Metadata.create(
                    id: metadataID,
                    reference: .init(
                        type: "blog.author",
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

private extension AddAuthor {
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
