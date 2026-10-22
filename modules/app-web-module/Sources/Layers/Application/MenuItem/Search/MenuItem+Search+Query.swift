public import WebModule

extension MenuItem.Search {
    public enum Query {
        public protocol Interface: Sendable {
            func search(menuId: String, query: Input.Query) async throws
                -> Output
        }
    }
}
