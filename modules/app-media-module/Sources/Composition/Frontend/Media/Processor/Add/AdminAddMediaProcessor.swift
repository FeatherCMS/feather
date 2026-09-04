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

struct AdminAddMediaProcessor {
    let controller: any AdminAddMediaProcessorController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminAddMediaProcessorDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminAddMediaProcessorDefaultInteractor(
                        repository: AdminMediaProcessorOpenAPIRepository(
                            api: context.mediaAdminAPI()
                        )
                    ),
                    presenter: AdminAddMediaProcessorDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
