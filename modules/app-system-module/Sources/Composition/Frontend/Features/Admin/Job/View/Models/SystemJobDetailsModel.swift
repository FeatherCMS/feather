import SystemAdminAPI

struct SystemJobDetailsModel: Sendable {
    let job: Components.Schemas.SystemJobSchema

    init(job: Components.Schemas.SystemJobSchema) {
        self.job = job
    }
}
