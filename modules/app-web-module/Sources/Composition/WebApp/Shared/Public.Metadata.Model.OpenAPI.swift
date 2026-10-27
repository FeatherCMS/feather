import OpenAPIRuntime
public import WebAppAPI

extension Public.Metadata.Model {
    public init(schema: Components.Schemas.MetadataContentSchema) {
        self.init(
            slug: schema.slug,
            title: schema.title,
            excerpt: schema.excerpt,
            imageURL: schema.imageURL,
            canonicalURL: schema.canonicalURL,
            noIndex: schema.noIndex,
            cssCodeInjection: schema.cssCodeInjection,
            javascriptCodeInjection: schema.javascriptCodeInjection,
            structuredDataCodeInjection: schema.structuredDataCodeInjection,
            publicationDateText: schema.publicationDate.map {
                DateFormatting.formatUnixTimestamp($0)
            },
            templateData: schema.templateData
        )
    }
}
