import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminEditMediaAssetController: Sendable {
    func getEditMediaAsset(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse

    func postEditMediaAsset(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}

extension AdminEditMediaAssetController {
    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(
            "/admin/media/assets/{id}/edit/",
            use: getEditMediaAsset
        )
        router.post(
            "/admin/media/assets/{id}/edit/",
            use: postEditMediaAsset
        )
    }
}
