import ContactDomain
public import ContactModule
public import FeatherApplication
public import FeatherModuleKit

extension FormField.Add {
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
                let model = try FormField.Model.create(
                    formId: input.formId ?? "",
                    key: input.key,
                    type: input.type,
                    label: input.label,
                    allowedValues: input.allowedValues,
                    isRequired: input.isRequired,
                    position: input.position
                )
                let field = try await scope.field.insert(model)
                if let formId = input.formId {
                    try await scope.field.assign(
                        formId: formId,
                        fieldId: field.id,
                        position: input.position
                    )
                }
                return .init(model: field)
            }
        }
    }
}
