import AdminOpenAPI
import Foundation

struct AdminListMediaProcessorModel: Sendable {
    let items: [Components.Schemas.MediaProcessorListItemSchema]
    let total: Int
    let page: Int
    let pageSize: Int
}
