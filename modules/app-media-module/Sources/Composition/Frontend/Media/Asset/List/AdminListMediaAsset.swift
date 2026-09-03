import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminListMediaAsset {
    let controller: any AdminListMediaAssetController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminListMediaAssetDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminListMediaAssetDefaultInteractor(
                        repository: AdminMediaAssetOpenAPIRepository(
                            api: context.mediaAdminAPI()
                        )
                    ),
                    presenter: AdminListMediaAssetDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
