public import WebModule

extension MenuItem.List {
    public enum Query {
        public protocol Interface: Sendable {
            func list(menuId: String) async throws -> Output
        }
    }
}
