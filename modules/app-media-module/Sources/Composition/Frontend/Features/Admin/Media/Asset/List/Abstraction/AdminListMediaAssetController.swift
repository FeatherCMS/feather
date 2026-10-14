import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminListMediaAssetController: Sendable {

    func getListMediaAssets(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse

    func remove(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response

}

extension AdminListMediaAssetController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(
            "/admin/media/assets/",
            use: getListMediaAssets
        )
        router.post(
            "/admin/media/assets/remove/",
            use: remove
        )
    }
}
