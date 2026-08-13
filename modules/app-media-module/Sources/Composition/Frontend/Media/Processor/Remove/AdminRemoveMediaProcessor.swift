import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminRemoveMediaProcessor {
    let controller: any AdminRemoveMediaProcessorController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminRemoveMediaProcessorDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminRemoveMediaProcessorDefaultInteractor(
                        repository: AdminMediaProcessorOpenAPIRepository(
                            api: context.mediaManagementAPI()
                        )
                    ),
                    presenter: AdminRemoveMediaProcessorDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
