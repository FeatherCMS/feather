import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

protocol AdminEditMediaAssetController: Sendable {
    func getEditMediaAsset(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

    func postEditMediaAsset(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response
}

extension AdminEditMediaAssetController {
    func route(
        on router: Router<DefaultRequestContext>
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
