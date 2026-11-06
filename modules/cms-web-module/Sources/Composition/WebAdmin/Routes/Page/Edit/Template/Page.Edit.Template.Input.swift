import Foundation
import WebModule

extension Page.Edit.Template {
    struct Input: Decodable, Sendable {
        struct Key: CodingKey {
            let stringValue: String
            let intValue: Int?

            init?(stringValue: String) {
                self.stringValue = stringValue
                self.intValue = nil
            }

            init?(intValue: Int) {
                self.stringValue = String(intValue)
                self.intValue = intValue
            }
        }

        let values: [String: String]

        init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: Key.self)
            var values: [String: String] = [:]
            for key in container.allKeys {
                if key.stringValue.hasPrefix("field.") {
                    values[String(key.stringValue.dropFirst("field.".count))] =
                        try container.decode(String.self, forKey: key)
                }
                else if key.stringValue == "field" {
                    try Self.decodeFields(
                        from: container.nestedContainer(
                            keyedBy: Key.self,
                            forKey: key
                        ),
                        path: "",
                        into: &values
                    )
                }
            }
            self.values = values
        }

        private static func decodeFields(
            from container: KeyedDecodingContainer<Key>,
            path: String,
            into values: inout [String: String]
        ) throws {
            for key in container.allKeys {
                let fieldPath = path.isEmpty
                    ? key.stringValue
                    : "\(path).\(key.stringValue)"
                if let value = try? container.decode(String.self, forKey: key) {
                    values[fieldPath] = value
                }
                else if let nested = try? container.nestedContainer(
                    keyedBy: Key.self,
                    forKey: key
                ) {
                    try decodeFields(
                        from: nested,
                        path: fieldPath,
                        into: &values
                    )
                }
            }
        }
    }
}
