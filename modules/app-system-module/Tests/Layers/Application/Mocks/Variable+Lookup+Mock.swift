import SystemModule

@testable import SystemApplication

extension SystemModule.Variable.Lookup {
    actor Mock: Interface {
        private let values: [String: String]

        init(values: [String: String] = [:]) {
            self.values = values
        }

        func get(_ key: String) async throws -> String? {
            values[key]
        }
    }
}
