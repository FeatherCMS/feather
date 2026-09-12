import FeatherAdmin
import Hummingbird

protocol AdminRemoveSystemPermissionController: Sendable {

    func getRemoveSystemPermissions(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response

    func postRemoveSystemPermissions(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response
}

extension AdminRemoveSystemPermissionController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(SystemPermissionRoutes.remove, use: getRemoveSystemPermissions)
        router.post(SystemPermissionRoutes.remove, use: postRemoveSystemPermissions)
    }
}
