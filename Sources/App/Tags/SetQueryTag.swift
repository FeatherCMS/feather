//
//  SetQueryTag.swift
//  FeatherCMS
//
//  Created by Tibor Bodecs on 2020. 06. 03..
//

import Vapor
import Leaf

struct SetQueryTag: LeafTag {
    
    static let name = "setQuery"

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
        
        if ctx.parameters.count > 1, let value = ctx.parameters[1].string {
            queryItems[input] = value
        }
        else {
            for newItem in input.split(separator: ",") {
                let array = newItem.split(separator: ":")
                guard array.count == 2 else {
                    continue
                }
                let k = String(array[0])
                let v = String(array[1])
                queryItems[k] = v
            }
        }

        let queryString = queryItems.map { $0 + "=" + $1 }.joined(separator: "&")
        return .string("\(path)?\(queryString)")
    }
}


