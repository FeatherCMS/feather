public import FeatherApplication
public import FeatherModuleKit
import MediaDomain
public import MediaModule

extension Variant.Detail {
    public struct UseCase: FeatherApplication.UseCase {

        let authorizer: any Authorizer
        let transaction: any TransactionExecutor<Variant.Detail.Scope>

        public init(
            authorizer: any Authorizer,
            transaction: any TransactionExecutor<Variant.Detail.Scope>
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
                    let variant = try await scope.variantDefinitions.find(
                        id: input.id
                    )
                else { return nil }
                let processors = try await scope.variantProcessors.list(
                    variantId: variant.id
                )
                return Output(
                    id: variant.id,
                    key: variant.key,
                    name: variant.name,
                    isRequired: variant.isRequired,
                    isActive: variant.isActive,
                    processors: processors.map(\.asVariantProcessorSearchItem),
                    createdAt: variant.createdAt,
                    updatedAt: variant.updatedAt
                )
            }
        }
    }
}
