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

protocol AdminRemoveMediaAssetController: Sendable {

    func getRemoveMediaAsset(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

    func postRemoveMediaAsset(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response
}

extension AdminRemoveMediaAssetController {

    func route(
        on router: Router<DefaultRequestContext>
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
