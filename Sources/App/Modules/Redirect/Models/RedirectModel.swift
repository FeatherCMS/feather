//
//  RedirectModel.swift
//  FeatherCMS
//
//  Created by Tibor Bödecs on 2020. 05. 30..
//

import FeatherCore

final class RedirectModel: ViperModel {
    typealias Module = RedirectModule

    static let name = "redirects"
    
    struct FieldKeys {
        static var source: FieldKey { "source" }
        static var destination: FieldKey { "destination" }
        static var statusCode: FieldKey { "status_code" }
    }

    // MARK: - fields

    @ID() var id: UUID?
    @Field(key: FieldKeys.source) var source: String
    @Field(key: FieldKeys.destination) var destination: String
    @Field(key: FieldKeys.statusCode) var statusCode: Int
    
    init() { }
    
    init(id: IDValue? = nil,
         source: String,
         destination: String,
         statusCode: Int = 301)
    {
        self.id = id
        self.source = source
        self.destination = destination
        self.statusCode = statusCode
    }

    var type: RedirectType {
        switch statusCode {
        case 301:
            return .permanent
        case 307:
            return .temporary
        default:
            return .normal
        }
    }
}
