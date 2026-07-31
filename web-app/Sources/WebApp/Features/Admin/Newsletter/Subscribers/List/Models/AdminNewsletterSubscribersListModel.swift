struct AdminNewsletterSubscribersListModel: Sendable {
    let items: [AdminNewsletterSubscriberListItem]
    let campaigns: [AdminNewsletterSubscriberCampaign]
    let search: String
    let campaignId: String
}
