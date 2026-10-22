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

extension Post.Add {
    struct Component: WebComponents.Component {

        struct State {
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
                            title: "Add post",
                            description: "Create a new blog post."
                        )
                    )
                )
                context.build(
                    BlogPostForm(
                        state: state.form,
                        action: state.routes.postAdd().description,
                        submitLabel: "Add post"
                    )
                )
            }
            .class("cms-section")
        }
    }
}
