import ContactDomain
public import ContactModule
public import FeatherApplication
public import FeatherModuleKit

extension FormField.List {
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
                if input.isUnassigned {
                    return .init(
                        items: try await scope.field.listUnassigned()
                            .map { Output.Item(model: $0) }
                    )
                }
                if let formKey = input.formKey {
                    guard let form = try await scope.form.findBy(key: formKey)
                    else {
                        return .init(items: [])
                    }
                    return .init(
                        items: try await scope.field.listBy(formId: form.id)
                            .map { Output.Item(model: $0) }
                    )
                }
                return .init(
                    items: try await scope.field.listBy(formId: input.formId)
                        .map { Output.Item(model: $0) }
                )
            }
        }
    }
}
