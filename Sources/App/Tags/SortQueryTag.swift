//
//  SortQueryTag.swift
//  FeatherCMS
//
//  Created by Tibor Bodecs on 2020. 06. 04..
//

import Vapor
import Leaf

struct SortQueryTag: LeafTag {
    
    static let name = "sortQuery"

    func render(_ ctx: LeafContext) throws -> LeafData {
        guard let input = ctx.parameters.first?.string else {
            throw "invalid \(Self.name) parameters"
        }

        let path = ctx.request?.url.path ?? ""
        let query = ctx.request?.url.query ?? ""
        
        var queryItems: [String: String] = [:]
        for item in query.split(separator: "&") {
            let array = item.split(separator: "=")
            guard array.count == 2 else {
                continue
            }
            let k = String(array[0])
            let v = String(array[1])
            queryItems[k] = v
        }
        
        let oldSort = queryItems["sort"]
        let oldOrder = queryItems["order"]
        queryItems["sort"] = input

        if oldSort != input {
            if oldOrder == "desc" {
                queryItems["order"] = "asc"
            }
        }
        else {
            if oldOrder == "desc" {
                queryItems["order"] = "asc"
            }
            if oldOrder == nil || oldOrder == "asc" {
                queryItems["order"] = "desc"
            }
        }

        let queryString = queryItems.map { $0 + "=" + $1 }.joined(separator: "&")
        return .string("\(path)?\(queryString)")
    }
}

