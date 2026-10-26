public import FeatherApplication
public import FeatherModuleKit
import MediaDomain
public import MediaModule

extension Variant.Processor.Add {
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
                    try await scope.variantDefinitions.find(
                        id: input.variantId
                    ) != nil
                else { throw Error.variantNotFound }
                let processor = try await scope.variantProcessors.insert(
                    Variant.Processor.Model.create(
                        variantId: input.variantId,
                        name: input.name,
                        matchExtensions: input.matchExtensions,
                        commandTemplate: input.commandTemplate,
                        isActive: input.isActive
                    )
                )
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
