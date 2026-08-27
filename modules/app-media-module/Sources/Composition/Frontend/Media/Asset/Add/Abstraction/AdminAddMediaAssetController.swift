import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminAddMediaAssetController: Sendable {

    func getAddMediaAsset(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

    func postAddMediaAsset(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response
}

extension AdminAddMediaAssetController {

    func route(
        on router: Router<DefaultRequestContext>
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
