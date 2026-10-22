public import FeatherApplication
public import FeatherModuleKit
import MediaDomain
public import MediaModule

extension Variant.Search {
    public struct UseCase: FeatherApplication.UseCase {

        let authorizer: any Authorizer
        let transaction: any TransactionExecutor<Variant.Search.Scope>

        public init(
            authorizer: any Authorizer,
            transaction: any TransactionExecutor<Variant.Search.Scope>
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
                var result = try await scope.variantDefinitions.list()
                    .map {
                        Variant.Search.Output.Item(
                            id: $0.id,
                            key: $0.key,
                            name: $0.name,
                            isRequired: $0.isRequired,
                            isActive: $0.isActive
                        )
                    }
                if let search = input.query.search?.lowercased(),
                    !search.isEmpty
                {
                    result = result.filter {
                        $0.key.lowercased().contains(search)
                            || $0.name.lowercased().contains(search)
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
