enum BlogSettingsVariableKey: String, CaseIterable, Sendable {
    case postListPath = "blog.post.list_path"
    case authorListPath = "blog.author.list_path"
    case tagListPath = "blog.tag.list_path"
    case postPathPrefix = "blog.post.path_prefix"
    case authorPathPrefix = "blog.author.path_prefix"
    case tagPathPrefix = "blog.tag.path_prefix"

    var fieldKey: String {
        switch self {
        case .postListPath:
            "postListPath"
        case .authorListPath:
            "authorListPath"
        case .tagListPath:
            "tagListPath"
        case .postPathPrefix:
            "postPathPrefix"
        case .authorPathPrefix:
            "authorPathPrefix"
        case .tagPathPrefix:
            "tagPathPrefix"
        }
    }

    var label: String {
        switch self {
        case .postListPath:
            "Blog post list path"
        case .authorListPath:
            "Blog author list path"
        case .tagListPath:
            "Blog tag list path"
        case .postPathPrefix:
            "Blog post path prefix"
        case .authorPathPrefix:
            "Blog author path prefix"
        case .tagPathPrefix:
            "Blog tag path prefix"
        }
    }

    var defaultValue: String {
        switch self {
        case .postListPath:
            "blog"
        case .authorListPath:
            "authors"
        case .tagListPath:
            "tags"
        case .postPathPrefix:
            "posts"
        case .authorPathPrefix:
            "authors"
        case .tagPathPrefix:
            "tags"
        }
    }

    var notes: String {
        switch self {
        case .postListPath:
            "Blog settings: public list path for posts."
        case .authorListPath:
            "Blog settings: public list path for authors."
        case .tagListPath:
            "Blog settings: public list path for tags."
        case .postPathPrefix:
            "Blog settings: public path prefix for posts."
        case .authorPathPrefix:
            "Blog settings: public path prefix for authors."
        case .tagPathPrefix:
            "Blog settings: public path prefix for tags."
        }
    }
}
