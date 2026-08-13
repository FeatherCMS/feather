import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminGetMediaAsset {
    let controller: any AdminGetMediaAssetController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminGetMediaAssetDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminGetMediaAssetDefaultInteractor(
                        repository: AdminMediaAssetOpenAPIRepository(
                            api: context.mediaManagementAPI()
                        )
                    ),
                    presenter: AdminGetMediaAssetDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
