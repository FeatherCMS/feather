import FeatherWebAdmin
import HTML
import Hummingbird
import RedirectApplication
import RedirectModule
import WebBuilders
import WebComponents

extension Rule.Edit {
    struct Page: Component {
        struct State {
            let id: String
            let form: Rule.Edit.Form.State
            let nonceToken: String
            let moreActions: [AdminButton.State]
            let routes: Rule.Router.Routes
        }

        let state: State

        func html(context: inout BuilderContext) -> Section {
            Section {
                context.build(
                    AdminBreadcrumb(links: state.routes.breadcrumb)
                )
                context.build(
                    AdminPageHeader(
                        state: .primary(
                            title: "Edit redirect rule",
                            description:
                                "Update the redirect rule configuration.",
                            moreActions: state.moreActions
                        )
                    )
                )
                context.build(
                    Rule.Edit.Form(
                        state: state.form,
                        action: state.routes.editPath(state.id),
                        nonceToken: state.nonceToken
                    )
                )
            }
            .class("cms-section")
        }
    }
}
