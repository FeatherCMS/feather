public import FeatherApplication
import FeatherDomain
public import FeatherModuleKit
import MediaDomain
public import MediaModule

extension Variant.Edit {
    public struct UseCase: FeatherApplication.UseCase {

        let authorizer: any Authorizer
        let transaction: any TransactionExecutor<Variant.Edit.Scope>

        public init(
            authorizer: any Authorizer,
            transaction: any TransactionExecutor<Variant.Edit.Scope>
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
                    var variant = try await scope.variantDefinitions.find(
                        id: input.id
                    )
                else { throw Variant.Edit.Error.notFound }
                variant.key = input.key.apply(to: variant.key)
                variant.name = input.name.apply(to: variant.name)
                variant.isRequired = input.isRequired.apply(
                    to: variant.isRequired
                )
                variant.isActive = input.isActive.apply(to: variant.isActive)
                let saved = try await scope.variantDefinitions.update(variant)
                let processors = try await scope.variantProcessors.list(
                    variantId: saved.id
                )
                return .init(
                    id: saved.id,
                    key: saved.key,
                    name: saved.name,
                    isRequired: saved.isRequired,
                    isActive: saved.isActive,
                    processors: processors.map {
                        Output.Processor(
                            id: $0.id,
                            variantId: $0.variantId,
                            name: $0.name,
                            matchExtensions: $0.matchExtensions,
                            commandTemplate: $0.commandTemplate,
                            isActive: $0.isActive
                        )
                    },
                    createdAt: saved.createdAt,
                    updatedAt: saved.updatedAt
                )
            }
        }
    }
}
