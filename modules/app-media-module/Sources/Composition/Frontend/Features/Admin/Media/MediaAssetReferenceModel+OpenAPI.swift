public import FeatherAdmin
import FeatherModuleKit
import FeatherValidation
import HTML
import Hummingbird
public import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension AdminMediaAsset {
    public init(schema: MediaAdminAPI.Components.Schemas.MediaAssetDetailSchema)
    {
        self.init(schema: schema, variants: [])
    }

    public init(
        schema: MediaAdminAPI.Components.Schemas.MediaAssetDetailSchema,
        variants: [AdminMediaAssetVariant]
    ) {
        let title = schema.title?.whitespaceTrimmed
        self.init(
            id: schema.id,
            name: schema.name,
            slugPath: schema.slugPath,
            url: schema.url,
            extension: schema._extension,
            contentType: schema.contentType,
            sizeBytes: schema.sizeBytes,
            variants: variants,
            title: title?.isEmpty == false ? title : schema.name,
            altText: schema.altText,
            status: schema.status
        )
    }
}
