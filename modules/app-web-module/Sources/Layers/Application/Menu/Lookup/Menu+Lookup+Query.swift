public import WebModule

extension Menu.Lookup {
    public enum Query {
        public protocol Interface: Sendable {
            func find(key: String) async throws -> Output?
        }
    }
}
