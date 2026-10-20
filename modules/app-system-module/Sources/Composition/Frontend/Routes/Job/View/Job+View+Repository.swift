import FeatherAdmin
import SystemModule

extension WebAdmin.System.Job.View {
    enum Repository {}
}

extension WebAdmin.System.Job.View.Repository {
    protocol Interface: Sendable {
        func get(id: String) async throws -> SystemJobDetailsModel
    }
}
