import SystemAdminAPI
import SystemModule

extension Job.View {
    struct Result: Sendable {
        let job: Components.Schemas.SystemJobSchema
    }
}
