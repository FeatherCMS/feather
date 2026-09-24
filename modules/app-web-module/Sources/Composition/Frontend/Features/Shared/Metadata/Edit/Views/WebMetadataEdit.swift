import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebAdminAPI
import WebBuilders
import WebComponents

struct WebMetadataEdit: Component {
    struct State {
        let id: String
        let form: WebMetadataForm.State
        let breadcrumb: [NewAdminBreadcrumb.Link]
        let action: String
        let navigationTabs: [NewAdminTabBar.Link]
        let pageHeader: NewAdminPageHeader.State
    }

    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(NewAdminBreadcrumb(links: state.breadcrumb))
            context.build(
                NewAdminPageHeader(state: state.pageHeader)
            )
            context.build(NewAdminTabBar(links: state.navigationTabs))
            context.build(
                WebMetadataForm(
                    state: state.form,
                    action: state.action,
                    submitLabel: "Edit entry"
                )
            )
        }
        .class("cms-section")
    }
}
