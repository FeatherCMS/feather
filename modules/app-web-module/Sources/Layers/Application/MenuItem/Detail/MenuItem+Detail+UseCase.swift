public import FeatherApplication
public import FeatherModuleKit
public import WebModule

extension MenuItem.Detail {
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
            let detail = try await query.run { scope in
                try await scope.menuItem.find(id: input.id)
            }
            guard detail.menuId == input.menuId else {
                throw Error(message: "Menu item not found")
            }
            return detail
        }
    }
}
