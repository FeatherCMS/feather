import FeatherOpenAPI

extension Campaign.Unsubscribe {
    struct RequestBody: RequestBodyRepresentable {
        var openAPIIdentifier: String {
            "AppNewsletterCampaignUnsubscribeRequestBody"
        }
        var contentMap: ContentMap {
            [.json: Content(Schema().reference())]
        }
    }
}
