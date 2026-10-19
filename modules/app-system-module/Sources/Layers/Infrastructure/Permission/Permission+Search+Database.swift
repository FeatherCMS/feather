import FeatherDBAL
public import FeatherInfrastructure
public import SystemApplication
public import SystemModule

extension SystemModule.Permission.Search {
    public struct Database: SystemModule.Permission.Search.Interface {
        private let listQuery: SystemModule.Permission.List.Query.Database

        public init(context: any DatabaseContext) {
            self.listQuery = .init(context: context)
        }

        public func search(
            query: SystemModule.Permission.Search.Input.Query
        ) async throws -> SystemModule.Permission.Search.Output {
            let listInput = makeListQuery(from: query)
            let list = try await listQuery.list(query: listInput)
            let total = try await listQuery.count(query: listInput)
            let items = list.items.map {
                SystemModule.Permission.Search.Output.Item(
                    id: $0.id,
                    key: $0.key,
                    name: $0.name,
                    notes: $0.notes
                )
            }
            return .init(items: items, total: total)
        }

        private func makeListQuery(
            from query: SystemModule.Permission.Search.Input.Query
        ) -> SystemModule.Permission.List.Input.Query {
            let sort = query.sort.map { rule in
                let field: SystemModule.Permission.List.Input.Query.Sort.Field =
                    switch rule.field {
                    case .key: .key
                    case .name: .name
                    case .notes: .notes
                    }
                return SystemModule.Permission.List.Input.Query.Sort(
                    field: field,
                    direction: rule.direction
                )
            }

            return .init(
                page: query.page,
                sort: sort,
                search: query.search,
                ids: query.ids
            )
        }
    }
}
