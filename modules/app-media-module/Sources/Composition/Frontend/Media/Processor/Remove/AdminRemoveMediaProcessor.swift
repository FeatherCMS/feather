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

struct AdminRemoveMediaProcessor {
    let controller: any AdminRemoveMediaProcessorController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminRemoveMediaProcessorDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminRemoveMediaProcessorDefaultInteractor(
                        repository: AdminMediaProcessorOpenAPIRepository(
                            api: context.mediaAdminAPI()
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
