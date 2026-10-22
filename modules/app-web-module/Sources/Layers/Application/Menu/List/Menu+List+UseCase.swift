public import FeatherApplication
public import FeatherModuleKit
public import WebDomain

extension Menu.List {
    public struct UseCase: FeatherApplication.UseCase {
        let authorizer: any Authorizer
        let query: any QueryExecutor<Scope>

        public init(authorizer: any Authorizer, query: any QueryExecutor<Scope>)
        {
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
            return try await query.run { try await $0.menu.list() }
        }
    }
}
