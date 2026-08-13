import FeatherAdmin
import SystemAdminAPI

struct AdminListSystemJobModel {
    let items: [Components.Schemas.SystemJobSchema]
    let total: Int
    let page: Int
    let pageSize: Int
}
