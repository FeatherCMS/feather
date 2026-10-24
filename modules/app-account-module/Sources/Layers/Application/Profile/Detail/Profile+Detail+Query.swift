public import AccountModule
public import AccountDomain


extension Profile.Detail {
    public enum Query {
        public protocol Interface: Sendable {
            func get(userId: String) async throws -> Profile.Model
        }
    }
}
