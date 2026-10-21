import FeatherApplication
import FeatherDBAL
public import FeatherInfrastructure
public import UserApplication
public import UserModule

extension Role.Table.Row {
    var asSearchItem: Role.Search.Output.Item {
        .init(
            id: id,
            key: key,
            name: name,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

extension Role.Search {
    public struct Database: Role.Search.Interface {
        public let context: DatabaseQueryContext

        public init(context: DatabaseQueryContext) {
            self.context = context
        }

        private func pageSizeOffset(_ page: Search.Page) -> (
            size: Int, offset: Int
        ) {
            let page = page.normalized()
            let pageIndex = page.number - 1
            let offset =
                pageIndex > Int.max / page.size
                ? Int.max : pageIndex * page.size
            return (page.size, offset)
        }

        private func sortDirectionSQL(_ direction: Search.SortDirection)
            -> String
        {
            switch direction {
            case .asc: "ASC"
            case .desc: "DESC"
            }
        }

        private func orderByRole(_ query: Role.Search.Input.Query) -> String {
            let sortParts = query.sort.map { rule -> String in
                let column: String
                switch rule.field {
                case .id: column = "id"
                case .name: column = "name"
                case .notes: column = "notes"
                }
                return "\(column) \(sortDirectionSQL(rule.direction))"
            }
            return (sortParts + ["id ASC"]).joined(separator: ", ")
        }

        public func search(query: Role.Search.Input.Query) async throws
            -> Role.Search.Output
        {
            let page = pageSizeOffset(query.page)
            let table = Role.Table(connection: context.connection)
            let items =
                try await table.list(
                    search: query.search,
                    orderBy: orderByRole(query),
                    limit: page.size,
                    offset: page.offset
                )
                .map(\.asSearchItem)
            let total = try await table.count(search: query.search)
            return .init(items: items, total: total)
        }
    }
}
