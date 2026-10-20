import FeatherWebAdmin
import HTML
import Hummingbird
import WebBuilders
import WebComponents

struct RedirectRuleAddPage: Component {
    let form: RedirectRuleAddForm.State
    let nonceToken: String

    func html(context: inout BuilderContext) -> Section {
        Section {
            context.build(
                AdminBreadcrumb(links: RedirectRuleRoutes.breadcrumb)
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
                    action: RedirectRuleRoutes.add.description,
                    nonceToken: nonceToken
                )
            )
        }
        .class("cms-section")
    }
}
