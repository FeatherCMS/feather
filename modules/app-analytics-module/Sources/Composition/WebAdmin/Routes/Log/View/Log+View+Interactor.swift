import AnalyticsModule

extension Log.View {
    enum Interactor {}
}

extension Log.View.Interactor {
    protocol Interface: Sendable {
        func execute(id: String) async throws -> Log.View.Model
    }
}
