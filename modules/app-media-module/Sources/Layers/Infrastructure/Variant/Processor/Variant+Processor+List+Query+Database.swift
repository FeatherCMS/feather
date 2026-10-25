import FeatherDBAL
public import FeatherInfrastructure
public import MediaApplication
import MediaDomain
public import MediaModule

extension Variant.Processor.List.Query {
    public struct Database: Interface {
        public let context: DatabaseQueryContext

        public init(context: DatabaseQueryContext) {
            self.context = context
        }

        public func list() async throws -> Variant.Processor.List.Output {
            let activeVariantIDs = Set(
                try await DatabaseAccessLayer<Variant.Table>(context: context)
                    .select { $0.where(\.isActive, equals: true) }
                    .map(\.id)
            )
            let processors = try await DatabaseAccessLayer<
                Variant.Processor.Table
            >(context: context)
            .select(as: Variant.Processor.Table.List.self) {
                $0.where(\.isActive, equals: true).order(by: \.name)
            }
            return .init(
                items: processors
                    .filter { activeVariantIDs.contains($0.variantId) }
                    .map(\.asDomain)
            )
        }
    }
}
