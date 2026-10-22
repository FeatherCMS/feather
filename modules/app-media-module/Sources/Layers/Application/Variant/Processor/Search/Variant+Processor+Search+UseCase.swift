public import FeatherApplication
public import FeatherModuleKit
import MediaDomain
public import MediaModule

extension Variant.Processor.Search {
    public struct UseCase: FeatherApplication.UseCase {

        let authorizer: any Authorizer
        let transaction: any TransactionExecutor<Variant.Processor.Search.Scope>
        public init(
            authorizer: any Authorizer,
            transaction: any TransactionExecutor<Variant.Processor.Search.Scope>
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
            let items = try await transaction.run { scope in
                guard
                    try await scope.variantDefinitions.find(id: input.variantId)
                        != nil
                else { throw Variant.Processor.Search.Error.variantNotFound }
                var result = try await scope.variantProcessors
                    .list(variantId: input.variantId)
                    .map {
                        Variant.Processor.Search.Output.Item(
                            id: $0.id,
                            variantId: $0.variantId,
                            name: $0.name,
                            matchExtensions: $0.matchExtensions,
                            commandTemplate: $0.commandTemplate,
                            isActive: $0.isActive
                        )
                    }
                if let search = input.query.search?.lowercased(),
                    !search.isEmpty
                {
                    result = result.filter {
                        $0.name.lowercased().contains(search)
                            || $0.matchExtensions.lowercased().contains(search)
                    }
                }
                return result
            }
            let size = max(1, input.query.page.size)
            let number = max(1, input.query.page.number)
            return .init(
                items: Array(items.dropFirst((number - 1) * size).prefix(size)),
                total: items.count
            )
        }
    }
}
