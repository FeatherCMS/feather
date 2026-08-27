import FeatherAdmin
import Hummingbird
import SystemAdminAPI

protocol AdminListSystemJobController: Sendable {
    func getSystemJobs(request: Request, context: DefaultRequestContext)
        async throws -> HTMLResponse
}

extension AdminListSystemJobController {
    func route(on router: Router<DefaultRequestContext>) {
        router.get("/admin/system/jobs/", use: getSystemJobs)
    }
}

protocol AdminListSystemJobInteractor: Sendable {
    func list(
        page: Int,
        search: String?
    ) async throws -> AdminListSystemJobModel
}

protocol AdminListSystemJobRepository: Sendable {
    func list() async throws -> [Components.Schemas.SystemJobSchema]
}
