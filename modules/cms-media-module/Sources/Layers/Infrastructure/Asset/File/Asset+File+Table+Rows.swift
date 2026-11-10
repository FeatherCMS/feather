import FeatherDBAL
import FeatherDomain
import MediaModule

extension Asset.File.Table: DatabaseTableWithInsert {
    struct Insert: DatabaseTableRowEncodable {
        let assetNodeId: String
        let storageObjectId: String
        let status: String
        let title: String?
        let altText: String?

        enum CodingKeys: String, CodingKey {
            case assetNodeId = "asset_node_id"
            case storageObjectId = "storage_object_id"
            case status
            case title
            case altText = "alt_text"
        }
    }
}

extension Asset.File.Table: DatabaseTableWithUpdate {
    struct Update: DatabaseTableRowEncodable {
        let status: String
        let title: OptionalFieldChange<String>
        let altText: OptionalFieldChange<String>

        enum CodingKeys: String, CodingKey {
            case status
        }

        func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(status, forKey: .status)
        }

        func afterEncode(values: inout DatabaseTableRowValues) throws {
            switch title {
            case .unchanged:
                values[Asset.File.Table.columns.title] = nil
            case .set(let value):
                values[Asset.File.Table.columns.title] = .value(value)
            case .clear:
                values[Asset.File.Table.columns.title] = .null
            }

            switch altText {
            case .unchanged:
                values[Asset.File.Table.columns.altText] = nil
            case .set(let value):
                values[Asset.File.Table.columns.altText] = .value(value)
            case .clear:
                values[Asset.File.Table.columns.altText] = .null
            }
        }

        init(
            status: String,
            title: String?,
            altText: String?
        ) {
            self.status = status
            self.title = title.map(OptionalFieldChange.set) ?? .clear
            self.altText = altText.map(OptionalFieldChange.set) ?? .clear
        }

        init(status: String) {
            self.status = status
            title = .unchanged
            altText = .unchanged
        }
    }
}
