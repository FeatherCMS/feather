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

struct AdminRemoveMediaAsset {
    let controller: any AdminRemoveMediaAssetController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminRemoveMediaAssetDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminRemoveMediaAssetDefaultInteractor(
                        repository: AdminMediaAssetOpenAPIRepository(
                            api: context.mediaAdminAPI()
                        )
                    ),
                    presenter: AdminRemoveMediaAssetDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
