import AuthAdminAPI
import AuthModule
import CSS
import FeatherValidation
import FeatherValidationFoundation
import FeatherWebAdmin
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import SystemAdminAPI
import SystemWebAdmin
import UserAdminAPI
import UserWebAdmin
import WebBuilders
import WebComponents

extension RolePermission.Edit.Form {
    public struct Input: Codable, Sendable {
        public let pairs: [String]?
        public let search: String?

        private enum CodingKeys: String, CodingKey {
            case pairs
            case pairsArray = "pairs[]"
            case search
        }

        public init(
            pairs: [String]? = nil,
            search: String? = nil
        ) {
            self.pairs = pairs
            self.search = search
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            if let values = try? container.decodeIfPresent(
                [String].self,
                forKey: .pairs
            ) {
                pairs = values
            }
            else if let value = try? container.decodeIfPresent(
                String.self,
                forKey: .pairs
            ) {
                pairs = [value]
            }
            else {
                pairs = try container.decodeIfPresent(
                    [String].self,
                    forKey: .pairsArray
                )
            }

            search = try container.decodeIfPresent(String.self, forKey: .search)
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encodeIfPresent(pairs, forKey: .pairs)
            try container.encodeIfPresent(search, forKey: .search)
        }

        var selectedPairs: Set<String> {
            Set((pairs ?? []).filter { !$0.isEmpty })
        }
    }
}
