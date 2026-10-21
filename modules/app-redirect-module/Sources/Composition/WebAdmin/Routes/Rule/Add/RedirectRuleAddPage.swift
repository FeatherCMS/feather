import FeatherWebAdmin
import HTML
import Hummingbird
import RedirectModule
import WebBuilders
import WebComponents

struct RedirectRuleAddPage: Component {
    let form: RedirectRuleAddForm.State
    let nonceToken: String
    let routes: RedirectModule.Rule.Router.Routes

    func html(context: inout BuilderContext) -> Section {
        Section {
            context.build(
                AdminBreadcrumb(links: routes.breadcrumb)
            )
            context.build(
                AdminPageHeader(
                    state: .primary(
                        title: "Add redirect rule",
                        description:
                            "Create a redirect from one path to another."
                    )
                )
            )
            context.build(
                RedirectRuleAddForm(
                    state: form,
                    action: routes.add.path,
                    nonceToken: nonceToken
                )
            )
        }
        .class("cms-section")
    }
}
