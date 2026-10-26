import AccountModule
import FeatherDBAL
import Foundation

extension Profile.Table: DatabaseTableWithDetail {
    struct Detail: DatabaseTableRowDecodable {
        let id: String
        let userId: String
        let firstName: String?
        let lastName: String?
        let profileImageAssetId: String?
        let createdAt: Date
        let updatedAt: Date

        enum CodingKeys: String, CodingKey {
            case id = "id"
            case userId = "user_id"
            case firstName = "first_name"
            case lastName = "last_name"
            case profileImageAssetId = "profile_image_asset_id"
            case createdAt = "created_at"
            case updatedAt = "updated_at"
        }
    }
}

extension Profile.Table: DatabaseTableWithInsert {
    struct Insert: DatabaseTableRowEncodable {
        let id: String
        let userId: String
        let firstName: String?
        let lastName: String?
        let profileImageAssetId: String?

        enum CodingKeys: String, CodingKey {
            case id
            case userId = "user_id"
            case firstName = "first_name"
            case lastName = "last_name"
            case profileImageAssetId = "profile_image_asset_id"
        }
    }
}

extension Profile.Table: DatabaseTableWithUpdate {
    struct Update: DatabaseTableRowEncodable {
        let firstName: String?
        let lastName: String?
        let profileImageAssetId: String?

        func afterEncode(values: inout DatabaseTableRowValues) throws {
            values[Profile.Table.columns.updatedAt] = .currentTimestamp
        }

        enum CodingKeys: String, CodingKey {
            case firstName = "first_name"
            case lastName = "last_name"
            case profileImageAssetId = "profile_image_asset_id"
        }
    }
}

extension Profile.Table: DatabaseTableWithDelete {}
