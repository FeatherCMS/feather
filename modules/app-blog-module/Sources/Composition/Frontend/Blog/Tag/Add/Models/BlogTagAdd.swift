import BlogAdminAPI
import BlogAppAPI
import FeatherWebAdmin
import FeatherValidation
import HTML
import Hummingbird
import MediaFrontend
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebFrontend

struct BlogTagAdd: Component {

    struct State {
        let form: BlogTagForm.State
        let breadcrumb: [AdminBreadcrumb.Link]
    }

    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(AdminBreadcrumb(links: state.breadcrumb))
            context.build(
                AdminPageHeader(
                    state: .primary(
                        title: "Add tag",
                        description: "Create a new blog tag."
                    )
                )
            )
            Div {
                context.build(
                    BlogTagForm(
                        state: state.form,
                        action: "/admin/blog/tags/add/",
                        submitLabel: "Add tag"
                    )
                )
            }
        }
        .class("cms-section")
    }
}
