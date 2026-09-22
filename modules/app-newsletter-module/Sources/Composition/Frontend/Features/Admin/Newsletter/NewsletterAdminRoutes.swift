import FeatherAdmin
import Hummingbird

enum NewsletterAdminRoutes {
    static let admin = RouterPath("admin")
    static let newsletter = admin.appendingPath(RouterPath("newsletter"))
    static let campaigns = newsletter.appendingPath(RouterPath("campaigns"))
    static let campaignAdd = newsletter.appendingPath(RouterPath("add"))
    static let campaignRemove = newsletter.appendingPath(RouterPath("remove"))
    static let campaignRemoveSelected = campaignRemove
    static let subscribers = newsletter.appendingPath(
        RouterPath("subscribers")
    )
    static let subscriberAdd = subscribers.appendingPath(RouterPath("add"))
    static let subscriberRemove = subscribers.appendingPath(
        RouterPath("remove")
    )

    static let breadcrumb: [NewAdminBreadcrumb.Link] = [
        .init(label: "Admin", link: "/admin/"),
        .init(label: "Newsletter", link: newsletter.description + "/"),
    ]

    private static let campaignID = RouterPath(":newsletterId")
    private static let issueID = RouterPath(":issueId")
    private static let subscriberID = RouterPath(":subscriberId")

    static let campaignDetailsRoute = campaignDetails(campaignID)
    static let campaignEditRoute = campaignEdit(campaignID)
    static let campaignRemoveRoute = campaignRemove(campaignID)
    static let issueListRoute = campaignIssues(campaignID)
    static let issueAddRoute = issueAdd(campaignID)
    static let issueDetailsRoute = issueDetails(
        newsletterID: campaignID,
        issueID: issueID
    )
    static let issueEditRoute = issueEdit(
        newsletterID: campaignID,
        issueID: issueID
    )
    static let issueRemoveRoute = issueRemove(
        newsletterID: campaignID,
        issueID: issueID
    )
    static let issueTestEmailRoute = issueTestEmail(
        newsletterID: campaignID,
        issueID: issueID
    )
    static let campaignSubscribersRoute = campaignSubscribers(campaignID)
    static let campaignSubscriberAddRoute = campaignSubscriberAdd(campaignID)
    static let campaignSubscriberListRoute = campaignSubscribers(campaignID)
    static let campaignSubscriberDetailsRoute = campaignSubscriberDetails(
        newsletterID: campaignID,
        subscriberID: subscriberID
    )
    static let campaignSubscriberEditRoute = campaignSubscriberEdit(
        newsletterID: campaignID,
        subscriberID: subscriberID
    )
    static let campaignSubscriberRemoveRoute = campaignSubscriberRemove(
        newsletterID: campaignID,
        subscriberID: subscriberID
    )
    static let campaignSubscriberRemoveSelectedRoute = campaignSubscriberRemove(
        campaignID
    )
    static let subscriberDetailsRoute = subscriberDetails(subscriberID)

    static func campaignDetails(_ id: RouterPath) -> RouterPath {
        newsletter.appendingPath(id).appendingPath(RouterPath("details"))
    }

    static func campaignEdit(_ id: RouterPath) -> RouterPath {
        newsletter.appendingPath(id).appendingPath(RouterPath("edit"))
    }

    static func campaignRemove(_ id: RouterPath) -> RouterPath {
        newsletter.appendingPath(id).appendingPath(RouterPath("remove"))
    }

    static func campaignIssues(_ id: RouterPath) -> RouterPath {
        newsletter.appendingPath(id).appendingPath(RouterPath("issues"))
    }

    static func issueAdd(_ id: RouterPath) -> RouterPath {
        campaignIssues(id).appendingPath(RouterPath("add"))
    }

    static func issueDetails(
        newsletterID: RouterPath,
        issueID: RouterPath
    ) -> RouterPath {
        campaignIssues(newsletterID).appendingPath(issueID)
    }

    static func issueEdit(
        newsletterID: RouterPath,
        issueID: RouterPath
    ) -> RouterPath {
        issueDetails(newsletterID: newsletterID, issueID: issueID)
            .appendingPath(RouterPath("edit"))
    }

    static func issueRemove(
        newsletterID: RouterPath,
        issueID: RouterPath
    ) -> RouterPath {
        issueDetails(newsletterID: newsletterID, issueID: issueID)
            .appendingPath(RouterPath("remove"))
    }

    static func issueTestEmail(
        newsletterID: RouterPath,
        issueID: RouterPath
    ) -> RouterPath {
        issueDetails(newsletterID: newsletterID, issueID: issueID)
            .appendingPath(RouterPath("test-email"))
    }

    static let issueTestEmailSelectedRoute = campaignIssues(campaignID)
        .appendingPath(RouterPath("test-email"))

    static func campaignSubscribers(_ id: RouterPath) -> RouterPath {
        newsletter.appendingPath(id).appendingPath(RouterPath("subscribers"))
    }

    static func campaignSubscriberAdd(_ id: RouterPath) -> RouterPath {
        campaignSubscribers(id).appendingPath(RouterPath("add"))
    }

    static func campaignSubscriberRemove(_ id: RouterPath) -> RouterPath {
        campaignSubscribers(id).appendingPath(RouterPath("remove"))
    }

    static func campaignSubscriberDetails(
        newsletterID: RouterPath,
        subscriberID: RouterPath
    ) -> RouterPath {
        campaignSubscribers(newsletterID).appendingPath(subscriberID)
    }

    static func campaignSubscriberEdit(
        newsletterID: RouterPath,
        subscriberID: RouterPath
    ) -> RouterPath {
        campaignSubscriberDetails(
            newsletterID: newsletterID,
            subscriberID: subscriberID
        )
        .appendingPath(RouterPath("edit"))
    }

    static func campaignSubscriberRemove(
        newsletterID: RouterPath,
        subscriberID: RouterPath
    ) -> RouterPath {
        campaignSubscriberDetails(
            newsletterID: newsletterID,
            subscriberID: subscriberID
        )
        .appendingPath(RouterPath("remove"))
    }

    static func subscriberDetails(_ id: RouterPath) -> RouterPath {
        subscribers.appendingPath(id)
    }

}
