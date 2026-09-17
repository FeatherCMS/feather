import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension NewAdminMediaAsset {
    public init(schema: MediaAdminAPI.Components.Schemas.MediaAssetDetailSchema)
    {
        self.init(schema: schema, variants: [])
    }

    public init(
        schema: MediaAdminAPI.Components.Schemas.MediaAssetDetailSchema,
        variants: [NewAdminMediaAssetVariant]
    ) {
        self.init(
            id: schema.id,
            name: schema.name,
            slugPath: schema.slugPath,
            url: schema.url,
            extension: schema._extension,
            contentType: schema.contentType,
            sizeBytes: schema.sizeBytes,
            variants: variants,
            title: schema.title,
            altText: schema.altText,
            status: schema.status
        )
    }
}
