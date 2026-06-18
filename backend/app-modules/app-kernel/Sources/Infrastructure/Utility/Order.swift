//
//  File.swift
//  server
//
//  Created by Tibor Bödecs on 2026. 02. 18..
//

public enum Order: String, Sendable & Equatable & Hashable & Codable,
    CaseIterable
{
    /// Ascending order
    case asc
    /// Descending order
    case desc
}
