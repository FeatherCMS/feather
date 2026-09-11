import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AdminNewsletterCampaignTabs: Component {
    enum Tab: String {
        case details
        case subscribers
        case issues
    }

    let campaignId: String
    let active: Tab

    func html(context: inout RenderContext) -> Div {
        context.render(AdminPillTabs(links: [
            .init(
                label: "Details",
                href: "/admin/newsletters/\(campaignId)/details/",
                isCurrent: active == .details
            ),
            .init(
                label: "Subscribers",
                href: "/admin/newsletters/\(campaignId)/subscribers/",
                isCurrent: active == .subscribers
            ),
            .init(
                label: "Issues",
                href: "/admin/newsletters/\(campaignId)/issues/",
                isCurrent: active == .issues
            ),
        ]))
    }
}
