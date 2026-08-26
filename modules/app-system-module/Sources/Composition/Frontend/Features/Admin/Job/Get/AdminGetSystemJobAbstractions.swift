import FeatherAdmin
import Hummingbird
import SystemAdminAPI

protocol AdminGetSystemJobController: Sendable {
    func getSystemJob(request: Request, context: DefaultRequestContext) async throws
        -> HTMLResponse
}

extension AdminGetSystemJobController {
    func route(on router: Router<DefaultRequestContext>) {
        router.get("/admin/system/jobs/{id}/", use: getSystemJob)
    }
}

protocol AdminGetSystemJobRepository: Sendable {
    func get(id: String) async throws -> Components.Schemas.SystemJobSchema
}
