public import FeatherApplication
public import SystemModule

//
//  Permission+Detail+Output.swift
//  app-system-module
//
//  Created by Tibor Bödecs on 2026. 04. 11.
//

extension Permission.Detail {
    public struct Output: FeatherApplication.DTO {
        public let id: String
        public let key: String
        public var name: String?
        public var notes: String?

        package init(
            id: String,
            key: String,
            name: String?,
            notes: String?
        ) {
            self.id = id
            self.key = key
            self.name = name
            self.notes = notes
        }
    }
}
