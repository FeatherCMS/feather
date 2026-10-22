import FeatherValidation
import FeatherWebAdmin
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebAdminAPI
import WebBuilders
import WebComponents

struct MetadataEdit: Component {
    struct State {
        let id: String
        let form: MetadataForm.State
        let breadcrumb: [AdminBreadcrumb.Link]
        let action: String
        let navigationTabs: [AdminTabBar.Link]
        let pageHeader: AdminPageHeader.State
    }

    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(AdminBreadcrumb(links: state.breadcrumb))
            context.build(
                AdminPageHeader(state: state.pageHeader)
            )
            context.build(AdminTabBar(links: state.navigationTabs))
            context.build(
                MetadataForm(
                    state: state.form,
                    action: state.action,
                    submitLabel: "Edit entry"
                )
            )
        }
        .class("cms-section")
    }
}
