public import FeatherApplication
public import FeatherModuleKit
import MediaDomain
public import MediaModule

extension Variant.Add {
    public struct UseCase: FeatherApplication.UseCase {

        let authorizer: any Authorizer
        let transaction: any TransactionExecutor<Variant.Add.Scope>

        public init(
            authorizer: any Authorizer,
            transaction: any TransactionExecutor<Variant.Add.Scope>
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
            let variant = try await transaction.run { scope in
                try await scope.variantDefinitions.insert(
                    Variant.Model.create(
                        key: input.key,
                        name: input.name,
                        isRequired: input.isRequired,
                        isActive: input.isActive
                    )
                )
            }
            return .init(
                detail: .init(
                    id: variant.id,
                    key: variant.key,
                    name: variant.name,
                    isRequired: variant.isRequired,
                    isActive: variant.isActive,
                    processors: [],
                    createdAt: variant.createdAt,
                    updatedAt: variant.updatedAt
                )
            )
        }
    }
}
