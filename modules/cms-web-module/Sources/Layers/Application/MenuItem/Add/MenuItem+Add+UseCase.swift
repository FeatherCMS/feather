public import FeatherApplication
public import FeatherModuleKit
import WebDomain
public import WebModule

extension MenuItem.Add {
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
                try await scope.menuItem.insert(
                    MenuItem.Model.create(
                        menuId: input.menuId,
                        label: input.label,
                        url: input.url,
                        priority: input.priority,
                        isBlank: input.isBlank,
                        permission: input.permission,
                        authentication: input.authentication,
                        notes: input.notes
                    )
                )
            }
            return Output(model: model)
        }
    }
}
