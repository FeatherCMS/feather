//
//  StaticPageModel.swift
//  FeatherCMS
//
//  Created by Tibor Bödecs on 2020. 06. 07..
//

import Vapor
import Fluent
import ViperKit
import ViewKit

final class StaticPageModel: ViperModel {
    typealias Module = StaticModule

    static let name = "pages"

    struct FieldKeys {
        static var title: FieldKey { "title" }
        static var content: FieldKey { "content" }
        
    }

    // MARK: - fields

    @ID() var id: UUID?
    @Field(key: FieldKeys.title) var title: String
    @Field(key: FieldKeys.content) var content: String

    init() { }
    
    init(id: UUID? = nil,
         title: String,
         content: String)
    {
        self.id = id
        self.title = title
        self.content = content
    }
}
