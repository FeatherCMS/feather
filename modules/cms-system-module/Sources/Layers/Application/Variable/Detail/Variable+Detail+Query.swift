public import SystemDomain
public import SystemModule

extension Variable.Detail {
    public enum Query {
        public protocol Interface: Sendable {
            func find(id: String) async throws -> SystemModule.Variable.Model
        }
    }
}
