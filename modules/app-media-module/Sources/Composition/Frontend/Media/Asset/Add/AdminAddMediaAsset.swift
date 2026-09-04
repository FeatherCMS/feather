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

struct AdminAddMediaAsset {
    let controller: any AdminAddMediaAssetController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminAddMediaAssetDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminAddMediaAssetDefaultInteractor(
                        repository: AdminMediaAssetOpenAPIRepository(
                            api: context.mediaAdminAPI()
                        )
                    ),
                    presenter: AdminAddMediaAssetDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
