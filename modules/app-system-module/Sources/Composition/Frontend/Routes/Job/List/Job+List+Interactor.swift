import FeatherAdmin
import SystemModule

extension WebAdmin.System.Job.List {
    enum Interactor {}
}

extension WebAdmin.System.Job.List.Interactor {
    protocol Interface: Sendable {
        func list(
            page: Int,
            search: String?,
            status: Int?
        ) async throws -> WebAdmin.System.Job.List.Model
    }
}
