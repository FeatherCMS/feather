struct AdminNewsletterSubscribersDirectoryModel: Sendable {
    let items: [AdminNewsletterSubscriberDirectoryItem]
    let campaigns: [AdminNewsletterSubscriberCampaignOption]
    let search: String
    let campaignId: String
}
