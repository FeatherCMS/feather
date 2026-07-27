import AdminOpenAPI
import Hummingbird

protocol AdminListSystemJobController: Sendable {
    func getSystemJobs(request: Request, context: AppRequestContext) async throws -> HTMLResponse
}

extension AdminListSystemJobController {
    func route(on router: Router<AppRequestContext>) {
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
