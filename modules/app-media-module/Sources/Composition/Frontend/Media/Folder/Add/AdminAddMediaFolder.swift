import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminAddMediaFolder {
    let controller: any AdminAddMediaFolderController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminAddMediaFolderDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminAddMediaFolderDefaultInteractor(
                        repository: AdminAddMediaFolderOpenAPIRepository(
                            api: context.mediaManagementAPI()
                        )
                    ),
                    presenter: AdminAddMediaFolderDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
