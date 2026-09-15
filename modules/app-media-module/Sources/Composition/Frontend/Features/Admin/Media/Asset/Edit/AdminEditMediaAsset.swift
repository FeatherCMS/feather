import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminEditMediaAsset {
    let controller: any AdminEditMediaAssetController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminEditMediaAssetDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditMediaAssetDefaultInteractor(
                        repository: AdminEditMediaAssetOpenAPIRepository(
                            api: context.mediaAdminAPI()
                        )
                    ),
                    presenter: AdminEditMediaAssetDefaultPresenter(
                        request: request,
                        context: context,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
