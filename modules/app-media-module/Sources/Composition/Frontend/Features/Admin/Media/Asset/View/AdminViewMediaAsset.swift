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

struct AdminViewMediaAsset {
    let controller: any AdminViewMediaAssetController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminViewMediaAssetDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminViewMediaAssetDefaultInteractor(
                        repository: AdminViewMediaAssetOpenAPIRepository(
                            api: context.mediaAdminAPI()
                        )
                    ),
                    presenter: AdminViewMediaAssetDefaultPresenter(
                        request: request,
                        context: context,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
