import AdminOpenAPI
import Hummingbird

protocol AdminGetSystemJobController: Sendable {
    func getSystemJob(request: Request, context: AppRequestContext) async throws -> HTMLResponse
}

extension AdminGetSystemJobController {
    func route(on router: Router<AppRequestContext>) {
        router.get("/admin/system/jobs/{id}/", use: getSystemJob)
    }
}

protocol AdminGetSystemJobRepository: Sendable {
    func get(id: String) async throws -> Components.Schemas.SystemJobSchema
}
