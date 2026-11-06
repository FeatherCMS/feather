import FeatherDBAL
public import FeatherInfrastructure
public import UserApplication
public import UserModule

extension Role.List.Query {
    public struct Database: Interface {
        private let accessLayer: DatabaseAccessLayer<Role.Table>

        public init(context: any DatabaseContext) {
            self.accessLayer = .init(context: context)
        }

        public func list(query: Role.List.Input.Query) async throws
            -> Role.List.Output
        {
            let items =
                try await accessLayer.select { initial in
                    applySearch(query.search, to: initial)
                        .order(by: [.init(by: \.key, .ascending)])
                        .limit(min(max(query.limit ?? 20, 1), 100))
                }
                .map {
                    Role.List.Output.Item(
                        id: $0.id,
                        key: $0.key,
                        name: $0.name
                    )
                }
            return .init(items: items)
        }

        private func applySearch(
            _ search: String?,
            to initial: DatabaseQuerySelect<Role.Table>
        ) -> DatabaseQuerySelect<Role.Table> {
            guard let search else { return initial }
            return initial.where(
                searchText: search,
                columns: [
                    DatabaseQueryTextColumn<Role.Table>(\.id),
                    DatabaseQueryTextColumn<Role.Table>(\.key),
                    DatabaseQueryTextColumn<Role.Table>(\.name),
                    DatabaseQueryTextColumn<Role.Table>(\.notes),
                ]
            )
        }
    }
}
