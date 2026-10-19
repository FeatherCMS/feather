public import SystemModule
public import FeatherApplication
public import FeatherModuleKit
import SystemDomain

extension Variable.Add {
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
                try await scope.variable.insert(
                    SystemModule.Variable.Model.create(
                        key: input.key,
                        value: input.value,
                        name: input.name,
                        notes: input.notes
                    )
                )
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
