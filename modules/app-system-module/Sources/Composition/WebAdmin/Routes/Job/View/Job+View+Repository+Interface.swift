import FeatherWebAdmin
import SystemModule

extension Job.View.Repository {
    protocol Interface: Sendable {
        func get(id: String) async throws -> SystemJobDetailsModel
    }
}
