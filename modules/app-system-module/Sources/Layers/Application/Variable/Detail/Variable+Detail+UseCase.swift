public import SystemModule
public import FeatherApplication
public import FeatherModuleKit
import SystemDomain

extension Variable.Detail {
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

            let model = try await query.run { scope in
                try await scope.variable.find(id: input.id)
            }
            return .init(
                id: model.id,
                key: model.key,
                value: model.value,
                name: model.name,
                notes: model.notes
            )
        }
    }
}
