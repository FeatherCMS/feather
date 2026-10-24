import FeatherOpenAPI

extension NewsletterCampaign {
    struct Tag: TagRepresentable {
        var name: String = "Newsletter"
        var description: String? = "Public newsletter endpoints."
    }
}
