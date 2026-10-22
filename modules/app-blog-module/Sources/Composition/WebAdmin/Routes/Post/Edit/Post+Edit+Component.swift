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
            let form: BlogPostForm.State
            let breadcrumb: [AdminBreadcrumb.Link]
            let routes: BlogWebAdmin.Router.Routes
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
                    BlogPostForm(
                        state: state.form,
                        metadataHref: state.routes
                            .postEditMetadata(
                                RouterPath(state.id),
                                RouterPath(state.id)
                            )
                            .description,
                        action: state.routes.postEdit(RouterPath(state.id))
                            .description,
                        submitLabel: "Edit post",
                        removeHref: state.routes
                            .postRemove(RouterPath(state.id))
                            .description,
                        removeLabel: "Remove post"
                    )
                )
            }
            .class("cms-section")
        }
    }
}
