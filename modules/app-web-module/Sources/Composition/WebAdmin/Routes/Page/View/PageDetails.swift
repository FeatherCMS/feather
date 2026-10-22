import FeatherModuleKit
import FeatherWebAdmin
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import Builders
import Components
import WebModule

struct PageDetails: Component {
    struct State {
        let rule: PageDetailsModel
        let breadcrumb: [AdminBreadcrumb.Link]
        let permissions: AdminListActions
    }

    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(
                AdminDetailView(
                    breadcrumb: state.breadcrumb,
                    pageHeader: .primary(
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

    private var actions: [AdminDetailView.Action] {
        var result: [AdminDetailView.Action] = []
        if state.permissions.allows(WebModule.Permissions.Pages.update) {
            result.append(
                .init(
                    label: "Edit page",
                    href: PageRoutes.edit(RouterPath(state.rule.id))
                        .description,
                    style: .primary
                )
            )
        }
        if state.permissions.allows(WebModule.Permissions.Pages.delete) {
            result.append(
                .init(
                    label: "Remove page",
                    href:
                        PageRoutes.details(RouterPath(state.rule.id))
                        .appendingPath(RouterPath("remove"))
                        .description,
                    style: .destructive
                )
            )
        }
        return result
    }
}
