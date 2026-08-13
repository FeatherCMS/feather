import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminEditMediaProcessor {
    let controller: any AdminEditMediaProcessorController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminEditMediaProcessorDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditMediaProcessorDefaultInteractor(
                        repository: AdminMediaProcessorOpenAPIRepository(
                            api: context.mediaManagementAPI()
                        )
                    ),
                    presenter: AdminEditMediaProcessorDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
