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
                            title: "Add post",
                            description: "Create a new blog post."
                        )
                    )
                )
                context.build(
                    Post.Form(
                        state: state.form,
                        browsePath: state.routes.imagePickerPath(
                            state.form.imageAssetId.key
                        ),
                        action: state.routes.postAddPath(),
                        submitLabel: "Add post"
                    )
                )
            }
            .class("cms-section")
        }
    }
}
