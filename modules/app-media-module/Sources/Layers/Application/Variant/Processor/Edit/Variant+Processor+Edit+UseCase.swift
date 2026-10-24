public import FeatherApplication
import FeatherDomain
public import FeatherModuleKit
import MediaDomain
public import MediaModule

extension Variant.Processor.Edit {
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
            return try await transaction.run { scope in
                guard
                    var processor = try await scope.variantProcessors.find(
                        id: input.id
                    ), processor.variantId == input.variantId
                else { throw Error.notFound }
                processor.update(
                    name: input.name,
                    matchExtensions: input.matchExtensions,
                    commandTemplate: input.commandTemplate,
                    isActive: input.isActive
                )
                let updated = try await scope.variantProcessors.update(
                    processor
                )
                return .init(
                    id: updated.id,
                    variantId: updated.variantId,
                    name: updated.name,
                    matchExtensions: updated.matchExtensions,
                    commandTemplate: updated.commandTemplate,
                    isActive: updated.isActive,
                    createdAt: updated.createdAt,
                    updatedAt: updated.updatedAt
                )
            }
        }
    }
}
