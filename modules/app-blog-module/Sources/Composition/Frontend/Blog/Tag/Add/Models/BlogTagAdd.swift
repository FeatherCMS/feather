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

struct BlogTagAdd: Component {

    struct State {
        let form: BlogTagForm.State
        let breadcrumb: [NewAdminBreadcrumb.Link]
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(NewAdminBreadcrumb(links: state.breadcrumb))
            context.render(
                NewAdminPageHeader(
                    state: .init(
                        title: "Add tag",
                        description: "Create a new blog tag."
                    )
                )
            )
            Div {
                context.render(
                    BlogTagForm(
                        state: state.form,
                        action: "/admin/blog/tags/add/",
                        submitLabel: "Add tag",
                        publishLabel: "Publish tag"
                    )
                )
            }
        }
        .class("cms-section")
    }
}
