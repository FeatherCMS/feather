public import FeatherApplication
public import FeatherModuleKit
import WebDomain
public import WebModule

extension Page.Edit {
    public struct UseCase: FeatherApplication.UseCase {
        let authorizer: any Authorizer
        let transaction: any TransactionExecutor<Scope>

        public init(
            authorizer: any Authorizer,
            transaction: any TransactionExecutor<Scope>
        ) {
            self.authorizer = authorizer
            self.transaction = transaction
        }

        public func execute(subject: Subject, input: Input) async throws
            -> Output
        {
            let action = Action()
            guard try await authorizer.can(subject: subject, perform: action)
            else {
                throw AuthError(kind: .forbidden, message: action.key.rawValue)
            }
            let (model, metadata) = try await transaction.run { scope in
                guard var model = try await scope.page.find(id: input.id) else {
                    throw Error(message: "Page not found")
                }
                guard
                    var metadata = try await scope.metadata.find(
                        referenceType: "web.page",
                        referenceId: input.id
                    )
                else {
                    throw Error(message: "Page metadata not found")
                }

                try model.update(
                    title: input.title,
                    excerpt: input.excerpt,
                    content: input.content,
                    imageAssetId: input.imageAssetId
                )
                if let metadataInput = input.metadata {
                    try metadata.update(
                        template: metadataInput.template,
                        slug: metadataInput.slug,
                        publicationDate: metadataInput.publicationDate,
                        expirationDate: metadataInput.expirationDate,
                        status: metadataInput.status,
                        title: metadataInput.title,
                        excerpt: metadataInput.excerpt,
                        imageURL: metadataInput.imageURL,
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
                return (
                    try await scope.page.update(model),
                    try await scope.metadata.update(metadata)
                )
            }
            return .init(
                id: model.id,
                title: model.title,
                excerpt: model.excerpt,
                content: model.content,
                imageAssetId: model.imageAssetId,
                metadata: metadata.asSnapshot,
                createdAt: model.createdAt,
                updatedAt: model.updatedAt
            )
        }
    }
}
