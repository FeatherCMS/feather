import AdminOpenAPI

extension AdminMediaAssetReferenceModel {
    init(schema: Components.Schemas.MediaAssetDetailSchema) {
        self.init(
            id: schema.id,
            storageKey: schema.storageKey,
            baseName: schema.baseName,
            type: schema._type,
            title: schema.title,
            altText: schema.altText,
            status: schema.status
        )
    }
}
