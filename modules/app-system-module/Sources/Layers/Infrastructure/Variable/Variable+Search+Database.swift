import FeatherDBAL
public import FeatherInfrastructure
public import SystemApplication
public import SystemModule

extension SystemModule.Variable.Search {
    public struct Database: SystemModule.Variable.Search.Interface {
        private let listQuery: SystemModule.Variable.List.Query.Database

        public init(context: any DatabaseContext) {
            self.listQuery = .init(context: context)
        }

        public func search(
            query: SystemModule.Variable.Search.Input.Query
        ) async throws -> SystemModule.Variable.Search.Output {
            let listInput = makeListQuery(from: query)
            let list = try await listQuery.list(query: listInput)
            let total = try await listQuery.count(query: listInput)
            let items = list.items.map {
                SystemModule.Variable.Search.Output.Item(
                    id: $0.id,
                    key: $0.key,
                    value: $0.value,
                    name: $0.name,
                    notes: $0.notes
                )
            }
            return .init(items: items, total: total)
        }

        private func makeListQuery(
            from query: SystemModule.Variable.Search.Input.Query
        ) -> SystemModule.Variable.List.Input.Query {
            let sort = query.sort.map { rule in
                let field: SystemModule.Variable.List.Input.Query.Sort.Field =
                    switch rule.field {
                    case .key: .key
                    case .name: .name
                    case .value: .value
                    case .notes: .notes
                    }
                return SystemModule.Variable.List.Input.Query.Sort(
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
