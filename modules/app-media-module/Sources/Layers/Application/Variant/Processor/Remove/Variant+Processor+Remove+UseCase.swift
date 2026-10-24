public import FeatherApplication
public import FeatherModuleKit
import MediaDomain
public import MediaModule

extension Variant.Processor.Remove {
    public struct UseCase: FeatherApplication.UseCase {

        let authorizer: any Authorizer
        let transaction: any TransactionExecutor<Variant.Processor.Remove.Scope>
        public init(
            authorizer: any Authorizer,
            transaction: any TransactionExecutor<Variant.Processor.Remove.Scope>
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
            _ = try await transaction.run { scope in
                let processors = try await scope.variantProcessors.list(
                    variantId: input.variantId
                )
                let ids = Set(
                    processors.map(\.id).filter { input.ids.contains($0) }
                )
                _ = try await scope.variantProcessors.delete(ids: Array(ids))
            }
            return .init()
        }
    }
}
