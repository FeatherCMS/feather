public import SystemModule
import FeatherDBAL
public import FeatherInfrastructure
public import SystemApplication

extension SystemModule.Variable.Lookup {
    public struct Database: SystemModule.Variable.Lookup.Interface {
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
    }
}
