import FeatherApplication
import FeatherDBAL
public import FeatherInfrastructure
public import MediaApplication
public import MediaModule

extension Variant.Search.Query {
    public struct Database: Interface {
        public let context: DatabaseQueryContext

        public init(context: DatabaseQueryContext) {
            self.context = context
        }

        public func search(
            query: Variant.Search.Input.Query
        ) async throws -> Variant.Search.Output {
            let page = query.page.normalized()
            let pageNumber = page.number - 1
            let offset =
                pageNumber > Int.max / page.size
                ? Int.max
                : pageNumber * page.size
            let accessLayer = DatabaseAccessLayer<Variant.Table>(
                context: context
            )

            let rows = try await accessLayer.select(as: Variant.Table.List.self)
            {
                var result = $0
                if let search = query.search {
                    result = result.where(
                        searchText: search,
                        columns: [
                            DatabaseQueryTextColumn<Variant.Table>(\.key),
                            DatabaseQueryTextColumn<Variant.Table>(\.name),
                        ]
                    )
                }
                return
                    result
                    .order(by: \.name)
                    .order(by: \.id)
                    .limit(page.size)
                    .offset(offset)
            }
            let total = try await accessLayer.selectCount { initial in
                guard let search = query.search else { return initial }
                return initial.where(
                    searchText: search,
                    columns: [
                        DatabaseQueryTextColumn<Variant.Table>(\.key),
                        DatabaseQueryTextColumn<Variant.Table>(\.name),
                    ]
                )
            }

            return .init(
                items: rows.map {
                    .init(
                        id: $0.id,
                        key: $0.key,
                        name: $0.name,
                        isRequired: $0.isRequired,
                        isActive: $0.isActive
                    )
                },
                total: total
            )
        }
    }
}
