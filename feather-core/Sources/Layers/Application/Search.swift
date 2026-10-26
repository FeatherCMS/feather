//
//  Search.swift
//  feather-core
//
//  Created by Binary Birds on 2026. 06. 18.

public enum Search {

    public struct Page: Sendable {
        public var size: Int
        public var number: Int

        public init(size: Int = 20, number: Int = 1) {
            self.size = size
            self.number = number
        }

        public func normalized(maxSize: Int = 100) -> Self {
            let maximumSize = max(1, maxSize)
            return .init(
                size: min(max(1, size), maximumSize),
                number: max(1, number)
            )
        }
    }

    public enum SortDirection: String, Sendable, CaseIterable {
        case asc
        case desc
    }
}
