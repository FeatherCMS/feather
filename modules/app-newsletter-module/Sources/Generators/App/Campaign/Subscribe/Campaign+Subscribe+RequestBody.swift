import FeatherOpenAPI

extension Campaign.Subscribe {
    struct RequestBody: RequestBodyRepresentable {
        var openAPIIdentifier: String {
            "AppNewsletterCampaignSubscriptionRequestBody"
        }
        var contentMap: ContentMap {
            [.json: Content(Campaign.Schemas.Subscription().reference())]
        }
    }
}
