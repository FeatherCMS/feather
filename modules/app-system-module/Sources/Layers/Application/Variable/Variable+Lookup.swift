public import SystemModule

extension Variable {
    public enum Lookup {
        public protocol Interface: Sendable {
            func get(_ key: String) async throws -> String?
        }
    }
}
