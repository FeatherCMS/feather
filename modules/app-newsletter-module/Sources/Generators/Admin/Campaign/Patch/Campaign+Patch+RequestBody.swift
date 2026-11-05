import FeatherOpenAPI

extension Campaign.Patch {
    struct RequestBody: JSONRequestBodyRepresentable {
        var openAPIIdentifier: String {
            "NewsletterCampaignPatchRequestBody"
        }
        var schema = Schema().reference()
    }
}
