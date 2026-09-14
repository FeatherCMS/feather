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

struct AdminViewMediaProcessor {
    let controller: any AdminViewMediaProcessorController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminViewMediaProcessorDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminViewMediaProcessorDefaultInteractor(
                        repository: AdminMediaProcessorOpenAPIRepository(
                            api: context.mediaAdminAPI()
                        )
                    ),
                    presenter: AdminViewMediaProcessorDefaultPresenter(
                        request: request,
                        context: context,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
