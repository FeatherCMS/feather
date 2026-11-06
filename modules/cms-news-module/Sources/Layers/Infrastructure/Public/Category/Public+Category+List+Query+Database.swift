import FeatherDBAL
public import FeatherInfrastructure
public import NewsApplication
import NewsDomain
import NewsModule

extension Public.Category.List.Query {
    public struct Database: Interface {
        private let accessLayer: DatabaseAccessLayer<Category.Table>

        public init(context: any DatabaseContext) {
            self.accessLayer = .init(context: context)
        }

        public func list() async throws -> [Item] {
            try await accessLayer.select(as: Category.Table.List.self) {
                $0.order(
                    by: [
                        .init(by: \.createdAt, .descending),
                        .init(by: \.id, .ascending),
                    ]
                )
            }
            .map {
                .init(
                    id: $0.id,
                    title: $0.title,
                    excerpt: $0.excerpt,
                    imageAssetId: $0.imageAssetId
                )
            }
        }
    }
}
