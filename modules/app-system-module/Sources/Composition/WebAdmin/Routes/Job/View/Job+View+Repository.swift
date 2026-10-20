import FeatherAdmin
import SystemModule

extension Job.View {
    enum Repository {}
}

extension Job.View.Repository {
    protocol Interface: Sendable {
        func get(id: String) async throws -> SystemJobDetailsModel
    }
}
