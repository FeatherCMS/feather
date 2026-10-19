public import SystemModule
public import SystemDomain

extension Variable.Detail {
    public enum Query {
        public protocol Interface: Sendable {
            func find(id: String) async throws -> SystemModule.Variable.Model
        }
    }
}
