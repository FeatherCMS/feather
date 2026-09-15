import FeatherAdmin
import FeatherValidation
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
        let breadcrumb: [NewAdminBreadcrumb.Link]
    }

    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(NewAdminBreadcrumb(links: state.breadcrumb))
            context.build(
                NewAdminPageHeader(
                    state: .init(
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
                    submitLabel: "Add page",
                    publishLabel: "Publish page"
                )
            )
        }
        .class("cms-section")
    }
}
