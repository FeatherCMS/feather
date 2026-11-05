import FeatherDBAL
public import FeatherInfrastructure
public import SystemApplication
public import SystemModule

extension SystemModule.Variable.Lookup.Query {
    public struct Database: Interface {
        private let accessLayer: DatabaseAccessLayer<Variable.Table>

        public init(context: any DatabaseContext) {
            self.accessLayer = .init(context: context)
        }

        public func get(_ key: String) async throws -> String? {
            let row = try await accessLayer.selectFirst(
                by: \.key,
                equals: key
            )
            return row?.value
        }

        public func get(keys: [String]) async throws -> [String: String] {
            guard !keys.isEmpty else { return [:] }
            let rows = try await accessLayer.select { query in
                query.where(\.key, in: keys)
            }
            return rows.reduce(into: [String: String]()) { result, row in
                result[row.key] = row.value
            }
        }
    }
}
