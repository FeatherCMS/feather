import FeatherDBAL
public import FeatherInfrastructure
public import MediaApplication
public import MediaModule

extension Variant.Detail.Query {
    public struct Database: Interface {
        public let context: DatabaseQueryContext

        public init(context: DatabaseQueryContext) {
            self.context = context
        }

        public func find(id: String) async throws -> Variant.Detail.Output? {
            let accessLayer = DatabaseAccessLayer<Variant.Table>(
                context: context
            )
            guard
                let variant = try await accessLayer.selectFirst(
                    by: \.id,
                    equals: id
                )
            else {
                return nil
            }

            let processorAccessLayer = DatabaseAccessLayer<
                Variant.Processor.Table
            >(
                context: context
            )
            let processors = try await processorAccessLayer.select(
                as: Variant.Processor.Table.List.self
            ) {
                $0.where(\.variantId, equals: id)
                    .order(by: \.name)
                    .order(by: \.id)
            }

            return .init(
                id: variant.id,
                key: variant.key,
                name: variant.name,
                isRequired: variant.isRequired,
                isActive: variant.isActive,
                processors: processors.map {
                    .init(
                        id: $0.id,
                        variantId: $0.variantId,
                        name: $0.name,
                        matchExtensions: $0.matchExtensions,
                        commandTemplate: $0.commandTemplate,
                        isActive: $0.isActive
                    )
                },
                createdAt: variant.createdAt,
                updatedAt: variant.updatedAt
            )
        }
    }
}
