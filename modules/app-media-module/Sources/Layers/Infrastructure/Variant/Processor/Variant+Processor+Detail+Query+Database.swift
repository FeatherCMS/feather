import FeatherDBAL
public import FeatherInfrastructure
public import MediaApplication
public import MediaModule

extension Variant.Processor.Detail.Query {
    public struct Database: Interface {
        public let context: DatabaseQueryContext

        public init(context: DatabaseQueryContext) {
            self.context = context
        }

        public func find(
            id: String,
            variantId: String
        ) async throws -> Variant.Processor.Detail.Output? {
            let accessLayer = DatabaseAccessLayer<Variant.Processor.Table>(
                context: context
            )
            guard
                let row = try await accessLayer.selectFirst(
                    by: \.id,
                    equals: id
                ),
                row.variantId == variantId
            else {
                return nil
            }

            return .init(
                id: row.id,
                variantId: row.variantId,
                name: row.name,
                matchExtensions: row.matchExtensions,
                commandTemplate: row.commandTemplate,
                isActive: row.isActive,
                createdAt: row.createdAt,
                updatedAt: row.updatedAt
            )
        }
    }
}
