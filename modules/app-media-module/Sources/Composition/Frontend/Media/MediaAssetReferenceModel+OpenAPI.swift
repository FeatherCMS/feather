import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

extension AdminMediaAssetReferenceModel {
    public init(schema: MediaAdminAPI.Components.Schemas.MediaAssetDetailSchema)
    {
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
