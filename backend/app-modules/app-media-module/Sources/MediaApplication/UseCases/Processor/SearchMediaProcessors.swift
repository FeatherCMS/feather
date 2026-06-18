import Application
import Foundation
import MediaDomain

public struct SearchMediaProcessors: UseCase {
    struct Action: PermissionAction {
        let key = MediaPermissions.Processors.list
    }

    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<WriteMedia>

    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<WriteMedia>
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
    }

    public struct Input: DTO {
        public let query: MediaProcessorList.Query
        public init(query: MediaProcessorList.Query) { self.query = query }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> MediaProcessorList {
        let action = Action()
        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        let items = try await filteredItems(input.query)
        let page = pageSizeOffset(input.query.page)
        let pagedItems = Array(items.dropFirst(page.offset).prefix(page.size))
        return .init(items: pagedItems)
    }

    public func count(
        subject: Subject,
        input: Input
    ) async throws -> Int {
        let action = Action()
        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        return try await filteredItems(input.query).count
    }

    private func filteredItems(
        _ query: MediaProcessorList.Query
    ) async throws -> [MediaProcessorList.Item] {
        try await transaction.run { context in
            var processors = try await context.processors.list()
                .map(\.asProcessorListItem)
            if let search = query.search?
                .trimmingCharacters(in: .whitespacesAndNewlines),
                !search.isEmpty
            {
                let term = search.lowercased()
                processors = processors.filter {
                    $0.id.lowercased().contains(term)
                        || $0.name.lowercased().contains(term)
                        || $0.matchExtensions.lowercased().contains(term)
                        || $0.commandTemplate.lowercased().contains(term)
                }
            }
            return sort(processors, query: query)
        }
    }

    private func pageSizeOffset(
        _ page: Search.Page
    ) -> (size: Int, offset: Int) {
        let size = max(1, page.size)
        let number = max(1, page.number)
        return (size, (number - 1) * size)
    }

    private func sort(
        _ items: [MediaProcessorList.Item],
        query: MediaProcessorList.Query
    ) -> [MediaProcessorList.Item] {
        let rule = query.sort.first ?? .init(field: .name, direction: .asc)
        return items.sorted { lhs, rhs in
            let result: ComparisonResult =
                switch rule.field {
                case .id: lhs.id.localizedCaseInsensitiveCompare(rhs.id)
                case .name: lhs.name.localizedCaseInsensitiveCompare(rhs.name)
                case .matchExtensions:
                    lhs.matchExtensions.localizedCaseInsensitiveCompare(
                        rhs.matchExtensions
                    )
                case .commandTemplate:
                    lhs.commandTemplate.localizedCaseInsensitiveCompare(
                        rhs.commandTemplate
                    )
                case .isRequired:
                    String(lhs.isRequired).compare(String(rhs.isRequired))
                case .isActive:
                    String(lhs.isActive).compare(String(rhs.isActive))
                case .createdAt, .updatedAt:
                    lhs.id.localizedCaseInsensitiveCompare(rhs.id)
                }
            return rule.direction == .asc
                ? result == .orderedAscending : result == .orderedDescending
        }
    }
}
