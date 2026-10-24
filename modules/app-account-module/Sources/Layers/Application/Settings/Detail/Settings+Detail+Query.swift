public import AccountModule
public import AccountDomain


extension Settings.Detail {
    public enum Query {
        public protocol Interface: Sendable {
            func get(userId: String) async throws -> Settings.Model
        }
    }
}
