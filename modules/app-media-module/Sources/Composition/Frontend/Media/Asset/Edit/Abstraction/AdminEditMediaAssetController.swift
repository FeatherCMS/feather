import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminEditMediaAssetController: Sendable {
    func getEditMediaAsset(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse

    func postEditMediaAsset(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AdminEditMediaAssetController {
    func route(
        on router: Router<AppRequestContext>
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
