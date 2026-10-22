import ContactDomain
public import ContactModule
public import FeatherApplication
public import FeatherModuleKit

extension Submission.List {
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
                guard let form = try await scope.form.findBy(key: input.formKey)
                else {
                    throw Error.formNotFound
                }
                return .init(
                    items: try await scope.submission.listBy(formId: form.id)
                        .map { Output.Item(model: $0) }
                )
            }
        }
    }
}
