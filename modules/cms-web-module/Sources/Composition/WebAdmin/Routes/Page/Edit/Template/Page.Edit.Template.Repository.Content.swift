import WebModule

extension Page.Edit.Template.Repository {
    struct Content: Sendable {
        let metadataID: String
        let slug: String
        let templateID: String
        let templateData: String?
    }
}
