//
//  CustomPage.swift
//  FeatherCMS
//
//  Created by Tibor Bodecs on 2020. 05. 01..
//

import Vapor
import Fluent

extension QueryBuilder {
    public func customPaginate(_ request: CustomPageRequest) -> EventLoopFuture<CustomPage<Model>> {
        let count = self.count()
        let items = self.copy().range(request.start..<request.end).all()
        return items.and(count).map { (models, total) in
            let totalPages = Int(ceil(Float(total) / Float(request.per)))
            return CustomPage(items: models, metadata: .init(page: request.page, per: request.per, total: totalPages))
        }
    }
}

extension QueryBuilder {
    
    public func customPaginate(for request: Request) -> EventLoopFuture<CustomPage<Model>> {
        do {
            let page = try request.query.decode(CustomPageRequest.self)
            return self.customPaginate(page)
        }
        catch {
            return request.eventLoop.makeFailedFuture(error)
        }
    }
}

public struct CustomPage<T>: Encodable where T: Encodable {

    public let items: [T]

    public let metadata: CustomPageMetadata

    public init(items: [T], metadata: CustomPageMetadata) {
        self.items = items
        self.metadata = metadata
    }

    public func map<U>(_ transform: (T) throws -> (U)) rethrows -> CustomPage<U> where U: Encodable {
        try .init(items: self.items.map(transform), metadata: self.metadata)
    }
}

public struct CustomPageMetadata: Encodable {
    public let page: Int
    public let per: Int
    public let total: Int
}

public struct CustomPageRequest: Decodable {
    public let page: Int
    public let per: Int

    enum CodingKeys: String, CodingKey {
        case page = "page"
        case per = "per"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.page = try container.decodeIfPresent(Int.self, forKey: .page) ?? 1
        self.per = try container.decodeIfPresent(Int.self, forKey: .per) ?? 7
    }

    public init(page: Int, per: Int) {
        self.page = page
        self.per = per
    }

    var start: Int { (self.page - 1) * self.per }
    var end: Int { self.page * self.per }
}
