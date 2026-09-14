import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminNewsletterCampaignTabs: Component {
    enum Tab: String {
        case details
        case subscribers
        case issues
    }

    let campaignId: String
    let active: Tab

    func html(context: inout RenderContext) -> Div {
        context.render(
            AdminPillTabs(links: [
                .init(
                    label: "Details",
                    href: "/admin/newsletter/\(campaignId)/details/",
                    isCurrent: active == .details
                ),
                .init(
                    label: "Subscribers",
                    href: "/admin/newsletter/\(campaignId)/subscribers/",
                    isCurrent: active == .subscribers
                ),
                .init(
                    label: "Issues",
                    href: "/admin/newsletter/\(campaignId)/issues/",
                    isCurrent: active == .issues
                ),
            ])
        )
    }
}
