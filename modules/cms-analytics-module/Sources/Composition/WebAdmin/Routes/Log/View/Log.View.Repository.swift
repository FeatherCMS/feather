import AnalyticsModule

extension Log.View {
    enum Repository {}
}

extension Log.View.Repository {
    protocol Interface: Sendable {
        func get(id: String) async throws -> Log.View.Model
    }
}
