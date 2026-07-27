import HTML
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
        Div {
            Style(
                """
                .admin-newsletter-campaign-tabs {
                    display: flex;
                    align-items: center;
                    border: 1px solid var(--cms-gray-3);
                    border-radius: 999px;
                    margin-bottom: 16px;
                    padding: 4px;
                    gap: 4px;
                    width: 100%;
                }
                .admin-newsletter-campaign-tabs a {
                    flex: 1;
                    border: 0;
                    border-radius: 999px;
                    background: transparent;
                    color: var(--cms-light-font);
                    padding: 8px 12px;
                    line-height: 1.2;
                    text-align: center;
                    cursor: pointer;
                    text-decoration: none;
                }
                .admin-newsletter-campaign-tabs a:hover:not(.is-current) {
                    color: var(--cms-link-hover);
                    text-decoration: underline;
                }
                .admin-newsletter-campaign-tabs a.is-current {
                    background: var(--cms-gray-4);
                    color: var(--cms-strong-font);
                }
                """
            )
            A("Details")
                .href("/admin/newsletters/\(campaignId)/details/")
                .if(active == .details) { $0.class("is-current") }
            A("Subscribers")
                .href("/admin/newsletters/\(campaignId)/subscribers/")
                .if(active == .subscribers) { $0.class("is-current") }
            A("Issues")
                .href("/admin/newsletters/\(campaignId)/issues/")
                .if(active == .issues) { $0.class("is-current") }
        }
        .class(
            "admin-media-asset-picker-tabs",
            "admin-newsletter-campaign-tabs"
        )
    }
}
