import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebAdminAPI
import WebComponents
import WebBuilders

struct WebPageEdit: Leaf {

    struct State {
        let id: String
        let isEdited: Bool
        let form: WebPageForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func html() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb).html()

            H1 {
                Span("Edit page")
                if let slug = state.form.metadata.slug.value,
                    !slug.trimmingCharacters(in: .whitespacesAndNewlines)
                        .isEmpty
                {
                    A {
                        Icon(svg: FeatherIcons.externalLink()).html()
                    }
                    .href(
                        "/\(slug.trimmingCharacters(in: .whitespacesAndNewlines))/"
                    )
                    .target(.blank)
                    .ariaLabel("Preview page")
                    .style(
                        "display:inline-flex;align-items:center;justify-content:center;width:1rem;height:1rem;margin-left:0.4rem;vertical-align:middle;"
                    )
                }
            }
            if state.isEdited { P("Page edited successfully.") }
            WebPageForm(
                state: state.form,
                metadataHref:
                    "/admin/web/pages/\(state.id)/edit/metadata/\(state.id)/",
                action: "/admin/web/pages/\(state.id)/edit/",
                submitLabel: "Edit page",
                removeHref: "/admin/web/pages/\(state.id)/remove/",
                removeLabel: "Remove page"
            ).html()
        }
        .class("cms-section")
    }
}
