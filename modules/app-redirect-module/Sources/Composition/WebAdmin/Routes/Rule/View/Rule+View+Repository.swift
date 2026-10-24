import RedirectApplication
import RedirectModule

extension Rule.View {
    enum Repository {}
}

extension Rule.View.Repository {
    protocol Interface: Sendable {

        func load(
            id: String
        ) async throws -> Rule.View.Model
    }
}
