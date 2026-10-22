import BlogDomain
public import BlogModule
public import FeatherApplication
public import FeatherModuleKit

extension Settings.Edit {
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
                var model = try await scope.settings.get()
                try model.update(
                    postListPath: input.postListPath,
                    authorListPath: input.authorListPath,
                    tagListPath: input.tagListPath,
                    postPathPrefix: input.postPathPrefix,
                    authorPathPrefix: input.authorPathPrefix,
                    tagPathPrefix: input.tagPathPrefix
                )
                return try await scope.settings.update(model)
            }
            return .init(
                postListPath: model.postListPath,
                authorListPath: model.authorListPath,
                tagListPath: model.tagListPath,
                postPathPrefix: model.postPathPrefix,
                authorPathPrefix: model.authorPathPrefix,
                tagPathPrefix: model.tagPathPrefix
            )
        }
    }
}
