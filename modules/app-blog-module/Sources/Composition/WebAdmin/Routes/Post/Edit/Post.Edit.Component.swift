import BlogAdminAPI
import BlogAppAPI
import BlogModule
import FeatherValidation
import FeatherWebAdmin
import HTML
import Hummingbird
import MediaWebAdmin
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebModuleWebAdmin

extension Post.Edit {
    struct Component: WebComponents.Component {

        struct State {
            let id: String
            let form: Post.Form.State
            let breadcrumb: [AdminBreadcrumb.Link]
            let routes: Post.Router.Routes
        }

        let state: State

        func html(context: inout BuilderContext) -> some BasicTag {
            Section {
                context.build(AdminBreadcrumb(links: state.breadcrumb))
                context.build(
                    AdminPageHeader(
                        state: .primary(
                            title: "Edit post",
                            description: "Update this blog post."
                        )
                    )
                )
                context.build(
                    Post.Form(
                        state: state.form,
                        browsePath: state.routes.imagePickerPath(
                            state.form.imageAssetId.key
                        ),
                        metadataHref: state.routes
                            .postEditMetadataPath(
                                state.id,
                                state.id
                            ),
                        action: state.routes.postEditPath(state.id),
                        submitLabel: "Edit post",
                        removeHref: state.routes
                            .postRemovePath(state.id),
                        removeLabel: "Remove post"
                    )
                )
            }
            .class("cms-section")
        }
    }
}
