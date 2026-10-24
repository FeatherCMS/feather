public import FeatherApplication
public import FeatherModuleKit
import WebDomain
public import WebModule

extension MenuItem.Edit {
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
                guard var model = try await scope.menuItem.find(id: input.id),
                    model.menuId == input.menuId
                else {
                    throw MenuItem.Edit.Error(message: "Menu item not found")
                }
                try model.update(
                    label: input.label,
                    url: input.url,
                    priority: input.priority,
                    isBlank: input.isBlank,
                    permission: input.permission,
                    authentication: input.authentication,
                    notes: input.notes
                )
                return try await scope.menuItem.update(model)
            }
            return Output(model: model)
        }
    }
}
