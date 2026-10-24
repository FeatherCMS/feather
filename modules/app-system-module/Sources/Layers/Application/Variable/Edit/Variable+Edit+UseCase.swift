public import FeatherApplication
public import FeatherModuleKit
import SystemDomain
public import SystemModule

extension Variable.Edit {
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
                guard
                    var model = try await scope.variable.find(
                        id: input.id
                    )
                else {
                    throw Variable.Edit.Error.notFound
                }
                try model.update(
                    key: input.key,
                    name: input.name,
                    value: input.value,
                    notes: input.notes
                )
                return try await scope.variable.update(model)
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
