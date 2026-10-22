public import FeatherApplication
public import FeatherModuleKit
import WebDomain
public import WebModule

extension Menu.Edit {
    public struct UseCase: FeatherApplication.UseCase {
        struct Error: UseCaseError {
            let message: String
        }

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
                guard var model = try await scope.menu.find(id: input.id) else {
                    throw Error(message: "Menu not found")
                }
                if let key = input.key,
                    let existing = try await scope.menu.find(key: key),
                    existing.id != input.id
                {
                    throw Error(message: "Menu key already exists")
                }
                try model.update(
                    key: input.key,
                    name: input.name,
                    notes: input.notes
                )
                return try await scope.menu.update(model)
            }
            return Output(model: model)
        }
    }
}
