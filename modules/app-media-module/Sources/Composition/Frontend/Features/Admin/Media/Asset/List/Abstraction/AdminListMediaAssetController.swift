import FeatherWebAdmin
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

}

extension AdminListMediaAssetController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(
            "/admin/media/assets/",
            use: getListMediaAssets
        )
    }
}
