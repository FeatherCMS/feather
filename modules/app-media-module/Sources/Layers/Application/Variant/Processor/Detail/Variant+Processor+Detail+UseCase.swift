public import FeatherApplication
public import FeatherModuleKit
import MediaDomain
public import MediaModule

extension Variant.Processor.Detail {
    public struct UseCase: FeatherApplication.UseCase {

        let authorizer: any Authorizer
        let transaction: any TransactionExecutor<Variant.Processor.Detail.Scope>

        public init(
            authorizer: any Authorizer,
            transaction: any TransactionExecutor<Variant.Processor.Detail.Scope>
        ) {
            self.authorizer = authorizer
            self.transaction = transaction
        }

        public func execute(subject: Subject, input: Input) async throws
            -> Output?
        {
            let action = Action()
            guard try await authorizer.can(subject: subject, perform: action)
            else {
                throw AuthError(kind: .forbidden, message: action.key.rawValue)
            }

            return try await transaction.run { scope in
                guard
                    let processor = try await scope.variantProcessors.find(
                        id: input.id
                    ),
                    processor.variantId == input.variantId
                else { return nil }
                return .init(
                    id: processor.id,
                    variantId: processor.variantId,
                    name: processor.name,
                    matchExtensions: processor.matchExtensions,
                    commandTemplate: processor.commandTemplate,
                    isActive: processor.isActive,
                    createdAt: processor.createdAt,
                    updatedAt: processor.updatedAt
                )
            }
        }
    }
}
