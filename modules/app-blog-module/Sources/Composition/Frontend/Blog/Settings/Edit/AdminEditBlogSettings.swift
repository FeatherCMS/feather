import BlogAdminAPI
import BlogAppAPI
import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import MediaFrontend
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebFrontend

struct AdminEditBlogSettings {
    let controller: any AdminEditBlogSettingsController

    init(
        apiBuilder: BlogAPIBuilder,
        renderingEngine: any RenderingEngine
    ) {
        self.controller = AdminEditBlogSettingsDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditBlogSettingsDefaultInteractor(
                        repository: AdminEditBlogSettingsOpenAPIRepository(
                            api: apiBuilder.makeBlogAdmin(context)
                        )
                    ),
                    presenter: AdminEditBlogSettingsDefaultPresenter(
                        request: request,
                        context: context,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
