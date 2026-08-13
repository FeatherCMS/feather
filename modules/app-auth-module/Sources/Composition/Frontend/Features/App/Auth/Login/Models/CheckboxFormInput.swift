import AuthAdminAPI
import AuthAppAPI
import CSS
import FeatherAdmin
import FeatherValidation
import FeatherValidationFoundation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import SystemAdminAPI
import SystemFrontend
import UserAdminAPI
import UserAppAPI
import UserFrontend
import WebStandards

//
//  File.swift
//  web-app
//
//  Addd by Tibor Bödecs on 2026. 03. 01..
//

public struct CheckboxFormInput: Codable, Sendable, Equatable, Hashable {
    public let value: Bool

    public init(value: Bool) {
        self.value = value
    }

    public init(from decoder: any Decoder) throws {
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

    public func encode(
        to encoder: any Encoder
    ) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.value ? "on" : "off")
    }
}
