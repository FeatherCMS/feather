import FeatherDBAL
public import FeatherInfrastructure
public import SystemApplication
public import SystemDomain
public import SystemModule

extension SystemModule.Variable.Detail.Query {
    public struct Database: SystemModule.Variable.Detail.Query.Interface {
        private let accessLayer: DatabaseAccessLayer<Variable.Table>

        public init(context: any DatabaseContext) {
            self.accessLayer = .init(context: context)
        }

        public func find(id: String) async throws
            -> SystemModule.Variable.Model
        {
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
                value: row.value,
                name: row.name,
                notes: row.notes
            )
        }
    }
}
