import FeatherAdmin
import FeatherContracts
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebContracts

struct WebPageDetails: Component {
    struct State {
        let rule: WebPageDetailsModel
        let breadcrumb: [NewAdminBreadcrumb.Link]
        let permissions: NewAdminListActions
    }

    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(
                NewAdminDetailView(
                    breadcrumb: state.breadcrumb,
                    pageHeader: .init(
                        title: "Web page details",
                        description: "Review the web page content."
                    ),
                    fields: [
                        .init(
                            label: "Title",
                            value: state.rule.title
                        ),
                        .init(
                            label: "Excerpt",
                            value: state.rule.excerpt.isEmpty
                                ? "—"
                                : state.rule.excerpt
                        ),
                        .init(
                            label: "Content",
                            value: state.rule.content
                        ),
                    ],
                    actions: actions
                )
            )
        }
        .class("cms-section")
    }

    private var actions: [NewAdminDetailView.Action] {
        var result: [NewAdminDetailView.Action] = []
        if state.permissions.allows(WebPermissions.Pages.update) {
            result.append(
                .init(
                    label: "Edit page",
                    href: WebPageRoutes.edit(RouterPath(state.rule.id))
                        .description,
                    style: .primary
                )
            )
        }
        if state.permissions.allows(WebPermissions.Pages.delete) {
            result.append(
                .init(
                    label: "Remove page",
                    href:
                        WebPageRoutes.details(RouterPath(state.rule.id))
                        .appendingPath(RouterPath("remove"))
                        .description,
                    style: .destructive
                )
            )
        }
        return result
    }
}
