import FeatherValidation
import FeatherWebAdmin
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebAdminAPI
import WebBuilders
import WebComponents

struct WebPageAdd: Component {

    struct State {
        let form: WebPageForm.State
        let breadcrumb: [AdminBreadcrumb.Link]
    }

    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(AdminBreadcrumb(links: state.breadcrumb))
            context.build(
                AdminPageHeader(
                    state: .primary(
                        title: "Add page",
                        description:
                            "Create and publish a page for the public website."
                    )
                )
            )
            context.build(
                WebPageForm(
                    state: state.form,
                    action: WebPageRoutes.add.description,
                    submitLabel: "Add page"
                )
            )
        }
        .class("cms-section")
    }
}
