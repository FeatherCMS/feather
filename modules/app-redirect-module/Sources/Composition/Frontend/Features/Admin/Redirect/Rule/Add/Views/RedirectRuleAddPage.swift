import FeatherAdmin
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
                NewAdminBreadcrumb(links: RedirectRuleRoutes.breadcrumb)
            )
            context.build(
                NewAdminPageHeader(
                    state: .init(
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
