public import FeatherApplication
public import FeatherModuleKit
import WebDomain
public import WebModule

extension MenuItem.Move {
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

        public func execute(subject: Subject, input: Input) async throws {
            let action = Action()
            guard try await authorizer.can(subject: subject, perform: action)
            else {
                throw AuthError(kind: .forbidden, message: action.key.rawValue)
            }
            try await transaction.run { scope in
                try await scope.menuItem.move(
                    id: input.id,
                    menuId: input.menuId,
                    beforeItemId: input.beforeItemId
                )
            }
        }
    }
}
