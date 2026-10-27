import WebModule

extension Page.Edit.Template {
    struct Model: Sendable {
        let pageID: String
        let metadataID: String
        let slug: String
        let templateID: String
        let templateTitle: String
        let fields: [WebModule.Template.Field]
        let templateData: String
        let error: String?
        let success: String?
        let formValues: [String: String]?

        init(
            pageID: String,
            metadataID: String,
            slug: String = "",
            templateID: String,
            templateTitle: String,
            fields: [WebModule.Template.Field],
            templateData: String,
            error: String?,
            success: String?,
            formValues: [String: String]? = nil
        ) {
            self.pageID = pageID
            self.metadataID = metadataID
            self.slug = slug
            self.templateID = templateID
            self.templateTitle = templateTitle
            self.fields = fields
            self.templateData = templateData
            self.error = error
            self.success = success
            self.formValues = formValues
        }
    }
}
