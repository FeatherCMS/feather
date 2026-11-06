import FeatherDBAL
public import FeatherInfrastructure
public import SystemApplication
public import SystemModule

extension SystemModule.Permission.Detail.Query {
    public struct Database: Interface {
        private let accessLayer: DatabaseAccessLayer<Permission.Table>

        public init(context: any DatabaseContext) {
            self.accessLayer = .init(context: context)
        }

        public func find(
            id: String
        ) async throws -> SystemModule.Permission.Detail.Output {
            guard
                let row = try await accessLayer.selectFirst(
                    by: \.id,
                    equals: id
                )
            else {
                throw QueryError.notFound
            }

            return .init(
                id: row.id,
                key: row.key,
                name: row.name,
                notes: row.notes
            )
        }
    }
}
