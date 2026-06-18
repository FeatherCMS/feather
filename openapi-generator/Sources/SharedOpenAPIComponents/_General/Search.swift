import FeatherOpenAPI
import Foundation
import OpenAPIKit30

public struct SearchQuerySchema: ObjectSchemaRepresentable {
    var items: SchemaRepresentable
    var sortFieldKeys: [String]?
    var filters: (any ObjectSchemaRepresentable)?

    var identifier: String {
        let suffix = "Schema"
        let oid = items.openAPIIdentifier
        if oid.hasSuffix(suffix) {
            return String(oid.dropLast(suffix.count))
        }
        return oid
    }

    // MARK: -

    public init<T: SchemaRepresentable>(
        items: T,
        sortFieldKeys: [String]? = nil,
        filters: (any ObjectSchemaRepresentable)? = nil
    ) {
        self.items = items
        self.sortFieldKeys = sortFieldKeys
        self.filters = filters
    }

    public var openAPIIdentifier: String {
        "\(identifier)SearchQuerySchema"
    }

    public var propertyMap: SchemaMap {
        var properties: SchemaMap = [
            "page": SearchPageSchema().reference(),
            "sort": SearchQuerySortListSchema(
                identifier: identifier,
                sortFieldKeys: sortFieldKeys
            ),
        ]
        if let filters {
            properties["filters"] = filters
        }
        return properties
    }
}

struct SearchPageSizeField: IntSchemaRepresentable {
    var example: Int? = 20
}

struct SearchPageNumberField: IntSchemaRepresentable {
    var example: Int? = 1
}

struct SearchStringField: StringSchemaRepresentable {
    var example: String? = "foo"
}

struct SearchQuerySortListItemFieldSchema: StringSchemaRepresentable {
    var identifier: String
    var sortFieldKeys: [String]?

    var openAPIIdentifier: String {
        "\(identifier)SearchQuerySortListItemFieldSchema"
    }

    var allowedValues: [String]? { sortFieldKeys }
    var example: String? { allowedValues?.first ?? "name" }
}

struct SearchSortDirectionField: StringSchemaRepresentable {
    var openAPIIdentifier: String { "SortDirection" }
    var allowedValues: [String]? = ["asc", "desc"]
    var example: String? = "asc"
}

struct SearchQuerySortListItemSchema: ObjectSchemaRepresentable {
    var identifier: String
    var sortFieldKeys: [String]?

    var openAPIIdentifier: String {

        "\(identifier)SearchQuerySortListItemSchema"
    }

    var propertyMap: SchemaMap {
        [
            "field": SearchQuerySortListItemFieldSchema(
                identifier: identifier,
                sortFieldKeys: sortFieldKeys
            ),
            "direction": SearchSortDirectionField().reference(),
        ]
    }
}

struct SearchQuerySortListSchema: ArraySchemaRepresentable {
    var identifier: String
    var sortFieldKeys: [String]?
    var required: Bool { false }

    var openAPIIdentifier: String {
        "\(identifier)SearchQuerySortListSchema"
    }

    var items: SchemaRepresentable? {
        SearchQuerySortListItemSchema(
            identifier: identifier,
            sortFieldKeys: sortFieldKeys
        )
    }
}

public struct SearchFilterSchema: ObjectSchemaRepresentable {
    public var propertyMap: SchemaMap {
        [
            "search": SearchStringField().reference(required: false)
        ]
    }

    public init() {}
}

struct SearchPageSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "size": SearchPageSizeField().reference(),
            "number": SearchPageNumberField().reference(),
        ]
    }
}

struct SearchResultItemSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap { [:] }
}

struct SearchResultItemsSchema: ArraySchemaRepresentable {
    private var privateItems: SchemaRepresentable
    public init<T: SchemaRepresentable>(_ items: T) {
        self.privateItems = items.reference()
    }

    var items: SchemaRepresentable? { privateItems }
}

struct SearchResultTotalField: IntSchemaRepresentable {
    var example: Int? = 123
}

public struct SearchResultDataSchema: ObjectSchemaRepresentable {

    private var items: SchemaRepresentable
    public init<T: SchemaRepresentable>(_ items: T) {
        self.items = items
    }

    public var propertyMap: SchemaMap {
        [
            "items": SearchResultItemsSchema(items),
            "total": SearchResultTotalField(),
        ]
    }
}

public struct SearchSchema: ObjectSchemaRepresentable {

    private var query: SearchQuerySchema

    public init(
        query: SearchQuerySchema
    ) {
        self.query = query
    }

    public var openAPIIdentifier: String {
        "\(query.identifier)SearchSchema"
    }

    public var propertyMap: SchemaMap {
        [
            "query": query.reference(),
            "data": SearchResultDataSchema(query.items),
        ]
    }
}

public struct SearchResponse: JSONResponseRepresentable {

    var query: SearchQuerySchema

    public init(query: SearchQuerySchema) {
        self.query = query
    }

    public var openAPIIdentifier: String {
        "\(underlyingSchema.openAPIIdentifier)SearchResponse"
    }

    private var underlyingSchema: SearchSchema {
        SearchSchema(query: query)
    }

    public var description: String = "Search response"
    public var schema: some SchemaRepresentable {
        underlyingSchema.reference()
    }
}

public struct SearchRequestBody: RequestBodyRepresentable {
    private var query: SearchQuerySchema

    public init(
        query: SearchQuerySchema
    ) {
        self.query = query
    }

    public var openAPIIdentifier: String {
        "\(query.identifier)SearchRequestBody"
    }

    public var contentMap: ContentMap {
        [
            .json: Content(query.reference())
        ]
    }
}
