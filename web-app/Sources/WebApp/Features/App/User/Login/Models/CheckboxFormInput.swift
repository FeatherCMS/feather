//
//  File.swift
//  web-app
//
//  Addd by Tibor Bödecs on 2026. 03. 01..
//

struct CheckboxFormInput: Codable, Sendable, Equatable, Hashable {
    let value: Bool

    init(value: Bool) {
        self.value = value
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let boolValue = try? container.decode(Bool.self) {
            self.value = boolValue
            return
        }
        if let intValue = try? container.decode(Int.self) {
            self.value = intValue != 0
            return
        }
        let rawValue = try container.decode(String.self)
        let normalized = rawValue.lowercased()
        self.value =
            normalized == "on" || normalized == "true" || normalized == "1"
    }

    func encode(
        to encoder: any Encoder
    ) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.value ? "on" : "off")
    }
}
