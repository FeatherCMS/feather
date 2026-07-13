struct AdminAddNewsletterSubscriberModel: Sendable {
    let email: String
    let firstName: String
    let lastName: String
    let selectedCampaignIds: Set<String>
    let campaigns: [AdminNewsletterSubscriberCampaignOption]
    let error: String?
}
