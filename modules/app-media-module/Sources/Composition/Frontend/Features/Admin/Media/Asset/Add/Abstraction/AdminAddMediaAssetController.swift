import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminAddMediaAssetController: Sendable {

    func getAddMediaAsset(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse

    func postAddMediaAsset(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}

extension AdminAddMediaAssetController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(
            "/admin/media/assets/add/",
            use: getAddMediaAsset
        )
        router.post(
            "/admin/media/assets/add/",
            use: postAddMediaAsset
        )
    }
}
