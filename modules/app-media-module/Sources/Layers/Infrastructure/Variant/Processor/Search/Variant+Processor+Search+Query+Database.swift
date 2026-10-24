import FeatherApplication
import FeatherDBAL
public import FeatherInfrastructure
public import MediaApplication
public import MediaModule

extension Variant.Processor.Search.Query {
    public struct Database: Interface {
        public let context: DatabaseQueryContext

        public init(context: DatabaseQueryContext) {
            self.context = context
        }

        public func search(
            variantId: String,
            query: Variant.Processor.Search.Input.Query
        ) async throws -> Variant.Processor.Search.Output? {
            let variant = try await DatabaseAccessLayer<Variant.Table>(
                context: context
            )
            .selectFirst(as: Variant.Table.Detail.self) {
                $0.where(\.id, equals: variantId)
            }
            guard variant != nil else { return nil }

            let page = query.page.normalized()
            let pageNumber = page.number - 1
            let offset =
                pageNumber > Int.max / page.size
                ? Int.max
                : pageNumber * page.size
            let accessLayer = DatabaseAccessLayer<Variant.Processor.Table>(
                context: context
            )

            let rows = try await accessLayer.select(
                as: Variant.Processor.Table.List.self
            ) { initial in
                var result = initial.where(\.variantId, equals: variantId)
                if let search = query.search {
                    result = result.where(
                        searchText: search,
                        columns: [
                            DatabaseQueryTextColumn<Variant.Processor.Table>(
                                \.name
                            ),
                            DatabaseQueryTextColumn<Variant.Processor.Table>(
                                \.matchExtensions
                            ),
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
                let result = initial.where(\.variantId, equals: variantId)
                guard let search = query.search else { return result }
                return result.where(
                    searchText: search,
                    columns: [
                        DatabaseQueryTextColumn<Variant.Processor.Table>(
                            \.name
                        ),
                        DatabaseQueryTextColumn<Variant.Processor.Table>(
                            \.matchExtensions
                        ),
                    ]
                )
            }

            return .init(
                items: rows.map {
                    .init(
                        id: $0.id,
                        variantId: $0.variantId,
                        name: $0.name,
                        matchExtensions: $0.matchExtensions,
                        commandTemplate: $0.commandTemplate,
                        isActive: $0.isActive
                    )
                },
                total: total
            )
        }
    }
}
