import FeatherAdmin
import FeatherValidation
import Foundation
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

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(NewAdminBreadcrumb(links: state.breadcrumb))
            context.render(
                NewAdminPageHeader(state: state.pageHeader)
            )
            context.render(NewAdminTabBar(links: state.navigationTabs))
            context.render(
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
