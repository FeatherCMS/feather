public import FeatherApplication
import FeatherDomain
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
            return try await transaction.run { scope in
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
                        template: .set(metadataInput.template),
                        slug: .set(metadataInput.slug),
                        publicationDate: metadataInput.publicationDate
                            .map(FieldChange.set) ?? .unchanged,
                        expirationDate: .init(
                            value: metadataInput.expirationDate,
                            shouldApply: true
                        ),
                        status: .set(metadataInput.status),
                        title: .init(
                            value: metadataInput.title,
                            shouldApply: true
                        ),
                        excerpt: .init(
                            value: metadataInput.excerpt,
                            shouldApply: true
                        ),
                        imageURL: .init(
                            value: metadataInput.imageURL,
                            shouldApply: true
                        ),
                        canonicalURL: .init(
                            value: metadataInput.canonicalURL,
                            shouldApply: true
                        ),
                        noIndex: .set(metadataInput.noIndex),
                        primaryKeyword: .init(
                            value: metadataInput.primaryKeyword,
                            shouldApply: true
                        ),
                        cssCodeInjection: .init(
                            value: metadataInput.cssCodeInjection,
                            shouldApply: true
                        ),
                        javascriptCodeInjection: .init(
                            value: metadataInput.javascriptCodeInjection,
                            shouldApply: true
                        ),
                        structuredDataCodeInjection: .init(
                            value: metadataInput.structuredDataCodeInjection,
                            shouldApply: true
                        )
                    )
                }
                let updatedModel = try await scope.page.update(model)
                let updatedMetadata = try await scope.metadata.update(metadata)
                return Output(
                    id: updatedModel.id,
                    title: updatedModel.title,
                    excerpt: updatedModel.excerpt,
                    content: updatedModel.content,
                    imageAssetId: updatedModel.imageAssetId,
                    metadata: updatedMetadata.asSnapshot,
                    createdAt: updatedModel.createdAt,
                    updatedAt: updatedModel.updatedAt
                )
            }
        }
    }
}
