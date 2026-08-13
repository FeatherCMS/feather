import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminNewsletterCampaignTabs: Component, FlowContent {
    enum Tab: String {
        case details
        case subscribers
        case issues
    }

    let campaignId: String
    let active: Tab

    func content() -> some BasicTag {
        AdminPillTabs(links: [
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
        ])
        .content()
    }
}
