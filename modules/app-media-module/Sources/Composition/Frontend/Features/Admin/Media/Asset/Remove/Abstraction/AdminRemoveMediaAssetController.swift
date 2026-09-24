import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminRemoveMediaAssetController: Sendable {

    func getRemoveMediaAsset(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse

    func postRemoveMediaAsset(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}

extension AdminRemoveMediaAssetController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(
            "/admin/media/assets/{id}/remove/",
            use: getRemoveMediaAsset
        )
        router.post(
            "/admin/media/assets/{id}/remove/",
            use: postRemoveMediaAsset
        )
    }
}
