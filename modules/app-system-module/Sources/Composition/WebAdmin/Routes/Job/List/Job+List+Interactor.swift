import FeatherAdmin
import SystemModule

extension Job.List {
    enum Interactor {}
}

extension Job.List.Interactor {
    protocol Interface: Sendable {
        func list(
            page: Int,
            search: String?,
            status: Int?
        ) async throws -> Job.List.Model
    }
}
