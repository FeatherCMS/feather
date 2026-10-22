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
    }
}

extension Profile.Table: DatabaseTableWithInsert {
    struct Insert: DatabaseTableRowEncodable {
        let id: String
        let userId: String
        let firstName: String?
        let lastName: String?
        let profileImageAssetId: String?
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
    }
}

extension Profile.Table: DatabaseTableWithDelete {}
