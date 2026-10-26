public import FeatherApplication
public import FeatherModuleKit
import WebDomain
public import WebModule

extension Page.Add {
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
            let model = try await transaction.run { scope in
                try await scope.page.insert(
                    Page.Model.create(
                        title: input.title,
                        excerpt: input.excerpt,
                        content: input.content,
                        imageAssetId: input.imageAssetId,
                        metadata: input.metadata
                    )
                )
            }
            return .init(
                id: model.id,
                title: model.title,
                excerpt: model.excerpt,
                content: model.content,
                imageAssetId: model.imageAssetId,
                metadata: model.metadata.asSnapshot,
                createdAt: model.createdAt,
                updatedAt: model.updatedAt
            )
        }
    }
}
