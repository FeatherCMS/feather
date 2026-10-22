public import FeatherApplication
import FeatherDomain
public import FeatherModuleKit
import RedirectDomain
public import RedirectModule

extension Rule.Edit {
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

        public func execute(
            subject: Subject,
            input: Input
        ) async throws -> Output {
            let action = Action()
            guard try await authorizer.can(subject: subject, perform: action)
            else {
                throw AuthError(kind: .forbidden, message: action.key.rawValue)
            }

            let model = try await transaction.run { scope in
                guard var model = try await scope.repository.find(id: input.id)
                else {
                    throw Error(message: "Rule not found")
                }
                try model.update(
                    source: input.source,
                    destination: input.destination,
                    statusCode: input.statusCode,
                    notes: input.notes
                )
                return try await scope.repository.update(model)
            }
            return .init(
                id: model.id,
                source: model.source,
                destination: model.destination,
                statusCode: model.statusCode,
                notes: model.notes
            )
        }
    }
}
