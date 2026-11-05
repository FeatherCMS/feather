import AccountModule
import FeatherDBAL
import FeatherInfrastructure
import Foundation

extension Profile {
    enum Table: DatabaseTable {
        static let name = "account_profile"
        static let columns = Columns()

        struct Columns: DatabaseTableColumns {
            let id = DatabaseTableColumn<String>(name: "id")
            let userId = DatabaseTableColumn<String>(name: "user_id")
            let firstName = DatabaseTableColumn<String?>(name: "first_name")
            let lastName = DatabaseTableColumn<String?>(name: "last_name")
            let profileImageAssetId = DatabaseTableColumn<String?>(
                name: "profile_image_asset_id"
            )
            let createdAt = DatabaseTableColumn<Date>(name: "created_at")
            let updatedAt = DatabaseTableColumn<Date>(name: "updated_at")
        }
    }
}
