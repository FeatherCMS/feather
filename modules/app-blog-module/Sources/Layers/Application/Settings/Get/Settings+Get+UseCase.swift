import BlogDomain
public import BlogModule
public import FeatherApplication
public import FeatherModuleKit

extension Settings.Get {
    public struct UseCase: FeatherApplication.UseCase {
        let authorizer: any Authorizer
        let query: any QueryExecutor<Scope>

        public init(
            authorizer: any Authorizer,
            query: any QueryExecutor<Scope>
        ) {
            self.authorizer = authorizer
            self.query = query
        }

        public func execute(subject: Subject, input: Input) async throws
            -> Output
        {
            let action = Action()
            guard try await authorizer.can(subject: subject, perform: action)
            else {
                throw AuthError(kind: .forbidden, message: action.key.rawValue)
            }
            let model = try await query.run { scope in
                try await scope.settings.get()
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
