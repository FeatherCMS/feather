public import BlogModule

extension PublicContent {
    public enum Repository {}
}

extension PublicContent.Repository {
    public protocol Interface: Sendable {
        func getRouteSettings() async throws -> Settings.PublicRoutes
    }
}
