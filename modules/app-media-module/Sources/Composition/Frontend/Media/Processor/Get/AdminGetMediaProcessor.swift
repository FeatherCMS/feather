import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminGetMediaProcessor {
    let controller: any AdminGetMediaProcessorController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminGetMediaProcessorDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminGetMediaProcessorDefaultInteractor(
                        repository: AdminMediaProcessorOpenAPIRepository(
                            api: context.mediaManagementAPI()
                        )
                    ),
                    presenter: AdminGetMediaProcessorDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
