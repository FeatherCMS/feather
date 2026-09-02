import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebStandards

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

    func deleteFolder(
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
        router.post(
            "/admin/media/assets/folders/{id}/remove/",
            use: deleteFolder
        )
    }
}
