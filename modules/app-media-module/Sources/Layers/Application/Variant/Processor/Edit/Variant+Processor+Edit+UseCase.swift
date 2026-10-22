public import FeatherApplication
import FeatherDomain
public import FeatherModuleKit
import MediaDomain
public import MediaModule

extension Variant.Processor.Edit {
    public struct UseCase: FeatherApplication.UseCase {

        let authorizer: any Authorizer
        let transaction: any TransactionExecutor<Variant.Processor.Edit.Scope>
        public init(
            authorizer: any Authorizer,
            transaction: any TransactionExecutor<Variant.Processor.Edit.Scope>
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
                else { throw Variant.Processor.Edit.Error.notFound }
                processor.name = input.name.apply(to: processor.name)
                processor.matchExtensions = input.matchExtensions.apply(
                    to: processor.matchExtensions
                )
                processor.commandTemplate = input.commandTemplate.apply(
                    to: processor.commandTemplate
                )
                processor.isActive = input.isActive.apply(
                    to: processor.isActive
                )
                let updated = try await scope.variantProcessors.update(
                    processor
                )
                return .init(detail: updated.asDetail)
            }
        }
    }
}
