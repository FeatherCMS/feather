//
//  FrontendContentModel.swift
//  FeatherCMS
//
//  Created by Tibor Bodecs on 2020. 06. 09..
//

import Vapor
import Fluent
import ViperKit
import ViewKit

final class FrontendContentModel: ViperModel {
    typealias Module = FrontendModule

    static let name = "contents"

    struct FieldKeys {
        static var module: FieldKey { "module" }
        static var model: FieldKey { "model" }
        static var reference: FieldKey { "reference" }

        static var slug: FieldKey { "slug" }
        static var date: FieldKey { "date" }
        static var status: FieldKey { "status" }
        static var filters: FieldKey { "filters" }
        static var feedItem: FieldKey { "feedItem" }

        static var title: FieldKey { "title" }
        static var excerpt: FieldKey { "excerpt" }
        static var imageKey: FieldKey { "image_key" }
        static var canonicalUrl: FieldKey { "canonical_url" }
    }
    
    // MARK: - fields
    
    enum Status: String, CaseIterable, Codable, FormFieldOptionRepresentable {
        case draft
        case published
        case archived
        
        var localized: String {
            self.rawValue.capitalized
        }

        var formFieldOption: FormFieldOption {
            .init(key: self.rawValue, label: self.localized)
        }
    }
    
    @ID() var id: UUID?
    @Field(key: FieldKeys.module) var module: String
    @Field(key: FieldKeys.model) var model: String
    @Field(key: FieldKeys.reference) var reference: UUID
    
    
    @Field(key: FieldKeys.slug) var slug: String
    @Field(key: FieldKeys.date) var date: Date
    @Field(key: FieldKeys.status) var status: Status
    @Field(key: FieldKeys.filters) var filters: [String]
    @Field(key: FieldKeys.feedItem) var feedItem: Bool

    @Field(key: FieldKeys.title) var title: String?
    @Field(key: FieldKeys.excerpt) var excerpt: String?
    @Field(key: FieldKeys.imageKey) var imageKey: String?
    @Field(key: FieldKeys.canonicalUrl) var canonicalUrl: String?

    init() { }
    
    init(id: UUID? = nil,
         module: String,
         model: String,
         reference: UUID,
         slug: String,
         date: Date = Date(),
         status: Status = .draft,
         filters: [String] = [],
         feedItem: Bool = false,
         title: String? = nil,
         excerpt: String? = nil,
         imageKey: String? = nil,
         canonicalUrl: String? = nil)
    {
        self.id = id
        self.module = module
        self.model = model
        self.reference = reference
        self.slug = slug
        self.date = date
        self.status = status
        self.filters = filters
        self.feedItem = feedItem
        self.title = title
        self.excerpt = excerpt
        self.imageKey = imageKey
        self.canonicalUrl = canonicalUrl
    }
}
