import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminEditMediaAsset {
    let controller: any AdminEditMediaAssetController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminEditMediaAssetDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditMediaAssetDefaultInteractor(
                        repository: AdminMediaAssetOpenAPIRepository(
                            api: context.mediaManagementAPI()
                        )
                    ),
                    presenter: AdminEditMediaAssetDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
