import ContactDomain
public import ContactModule
public import FeatherApplication
public import FeatherModuleKit

extension FormField.Edit {
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

        public func execute(
            subject: Subject,
            input: Input
        ) async throws -> Output {
            let action = Action()
            guard try await authorizer.can(subject: subject, perform: action)
            else {
                throw AuthError(kind: .forbidden, message: action.key.rawValue)
            }
            return try await transaction.run { scope in
                guard
                    var value = try await scope.field.findBy(
                        id: input.id,
                        formId: input.formId
                    )
                else {
                    throw Error(message: "Contact form field not found")
                }
                try value.update(
                    key: input.key,
                    type: input.type,
                    label: input.label,
                    allowedValues: input.allowedValues,
                    isRequired: input.isRequired,
                    position: input.position
                )
                return .init(model: try await scope.field.update(value))
            }
        }
    }
}
