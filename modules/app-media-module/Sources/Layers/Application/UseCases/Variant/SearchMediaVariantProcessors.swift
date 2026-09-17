import FeatherApplication
import FeatherContracts
import MediaContracts
import MediaDomain

public struct SearchMediaVariantProcessors: UseCase {
    struct Action: PermissionAction { let key = MediaPermissions.VariantProcessors.list }
    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<WriteMedia>
    public init(authorizer: any Authorizer, transaction: any TransactionExecutor<WriteMedia>) { self.authorizer = authorizer; self.transaction = transaction }
    public struct Input: DTO { public let variantId: String; public let query: MediaVariantProcessorList.Query; public init(variantId: String, query: MediaVariantProcessorList.Query) { self.variantId = variantId; self.query = query } }

    public func execute(subject: Subject, input: Input) async throws -> MediaVariantProcessorList {
        let action = Action()
        guard try await authorizer.can(subject: subject, perform: action) else { throw AuthError(kind: .forbidden, message: action.key.rawValue) }
        let items = try await transaction.run { scope in
            var result = try await scope.variantProcessors.list(variantId: input.variantId).map(\.asVariantProcessorListItem)
            if let search = input.query.search?.lowercased(), !search.isEmpty { result = result.filter { $0.name.lowercased().contains(search) || $0.matchExtensions.lowercased().contains(search) } }
            return result
        }
        let size = max(1, input.query.page.size)
        let number = max(1, input.query.page.number)
        return .init(items: Array(items.dropFirst((number - 1) * size).prefix(size)))
    }

    public func count(subject: Subject, input: Input) async throws -> Int {
        let action = Action()
        guard try await authorizer.can(subject: subject, perform: action) else { throw AuthError(kind: .forbidden, message: action.key.rawValue) }
        return try await transaction.run { scope in
            let items = try await scope.variantProcessors.list(variantId: input.variantId)
            guard let search = input.query.search?.lowercased(), !search.isEmpty else { return items.count }
            return items.filter { $0.name.lowercased().contains(search) || $0.matchExtensions.lowercased().contains(search) }.count
        }
    }
}
