import FeatherApplication
import FeatherDBAL
public import FeatherInfrastructure
public import UserApplication
import UserDomain
public import UserModule

extension Identity.Table.Row {
    var asIdentityStatus: Identity.Model.Status {
        .init(rawValue: status) ?? .deactivated
    }

    func asSearchItem(roles: [String]) -> Identity.Search.Output.Item {
        .init(
            id: id,
            name: name,
            status: asIdentityStatus,
            roles: roles,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

extension Identity.Search {
    public struct Database: Identity.Search.Interface {
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

        private func orderByIdentity(_ query: Identity.Search.Input.Query)
            -> String
        {
            let sortParts = query.sort.map { rule -> String in
                let column: String
                switch rule.field {
                case .id: column = "id"
                }
                return "\(column) \(sortDirectionSQL(rule.direction))"
            }
            return (sortParts + ["id ASC"]).joined(separator: ", ")
        }

        public func search(query: Identity.Search.Input.Query) async throws
            -> Identity.Search.Output
        {
            let page = pageSizeOffset(query.page)
            let table = Identity.Table(connection: context.connection)
            let rows = try await table.list(
                search: query.search,
                role: query.role,
                orderBy: orderByIdentity(query),
                limit: page.size,
                offset: page.offset
            )
            var items: [Identity.Search.Output.Item] = []
            for row in rows {
                items.append(
                    row.asSearchItem(
                        roles: try await table.listRoleNames(identityId: row.id)
                    )
                )
            }
            let total = try await table.count(
                search: query.search,
                role: query.role
            )
            return .init(items: items, total: total)
        }
    }
}
