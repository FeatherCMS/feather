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
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

    func removeConfirmation(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response

    func remove(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response

}

extension AdminListMediaAssetController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            "/admin/media/assets/",
            use: getListMediaAssets
        )
        router.get(
            "/admin/media/assets/remove/",
            use: removeConfirmation
        )
        router.post(
            "/admin/media/assets/remove/",
            use: remove
        )
    }
}
