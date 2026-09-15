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

struct BlogAuthorAdd: Component {

    struct State {
        let form: BlogAuthorForm.State
        let breadcrumb: [NewAdminBreadcrumb.Link]
    }

    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(NewAdminBreadcrumb(links: state.breadcrumb))
            context.build(
                NewAdminPageHeader(
                    state: .init(
                        title: "Add author",
                        description: "Create a new blog author."
                    )
                )
            )
            context.build(
                BlogAuthorForm(
                    state: state.form,
                    action: "/admin/blog/authors/add/",
                    submitLabel: "Add author",
                    publishLabel: "Publish author"
                )
            )
        }
        .class("cms-section")
    }
}
