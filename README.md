![Feather CMS](https://github.com/BinaryBirds/feather/blob/main/Assets/GitHub-Lead.png?raw=true)

# Feather CMS 🦚

Feather is a modern Swift-based content management system powered by Vapor 4.

## Requirements 

To use Feather CMS you'll have to install Swift 5.2 or greater. 

In other words Feather has the exact same system requirements as [Vapor 4](https://docs.vapor.codes/4.0/).

It is recommended that you follow these instructions in the exact order presented.

## Installation

- Clone or download the source files using this repository

```bash
git clone https://github.com/BinaryBirds/feather.git
```

- Setup the `.env.development` file using the `make env` command or config the following values by hand according to your needs:

```bash
# the base url of your web server
BASE_URL="http://localhost:8080"

# the base location of the server files (Public, Resources)
BASE_PATH="/path/to/feather/" 
```

- Created a `Public/assets` directory and ensure that you server has both read and write permissions  (use `chmod` and `chown` if necessary).
- Open the project via the `Package.swift` file using Xcode and set the custom working directory for the `Run` scheme.
- You don't need to generate an `xcodeproj` file anymore, please always open the `Package.swift` file if possible.
- Before running the project in Xcode, don't forget to set the [Custom Working directory (DerivedData)](https://theswiftdev.com/beginners-guide-to-server-side-swift-using-vapor-4/) to the root of the project. 
    - In Xcode click on the "Run" target -> Select "Edit Scheme..." -> "Run" -> "Options" tab -> Check the "Use custom working directory:" checkbox and select the root of your Vapor project.
- You can also compile the project and run the server (without Xcode) using one of the following commands:
    - `make run`
    - `swift run Run` 
    - `vapor build && vapor run serve`
- Build and run the project and enjoy your Feather powered site at [https://localhost:8080/](https://localhost:8080/)
- Migration & sample content installation will be performed at the first time when you hit the URL.
- You can log in to the admin using the `feather@binarybirds.com` & `FeatherCMS` account. 
- Please change the default email & password using the admin / user menu. 😅

### nginx

Setup [nginx](https://docs.vapor.codes/4.0/deploy/nginx/) as a reverse proxy server.

You can disable the file middleware in this case in the `configure.swift` file if you prefer nginx as a static file server.

Check the link for more instructions and please note that nginx is the preferred way of hosting Vapor / Feather based apps.

### PostgreSQL

- First of all, you will need a running PostgreSQL database server.
- In the `Package.swift` file uncomment the PosgreSQL related dependency.
- Add the following `DB_URL` variable to your `.env.development` file:

```bash
# change the user, pass, host, port and db name according to your needs 
DB_URL=postgres://myuser:mypass@localhost:5432/mydb
```
- Uncomment the psql related code in the configure.swift file and comment out the sqlite configs.
- That's it. You are ready to use the PostgreSQL driver.

### Other database drivers

It is possible to use MySQL (MariaDB) or MongoDB as your database via the [Fluent](https://docs.vapor.codes/4.0/fluent/overview/) framework.

You should follow the instructions using the official Vapor docs to setup the right driver, but please note that the preferred driver is PosgreSQL (and SQLite). 

---

## Modules

The architecture of Feather CMS is pretty much the same as the one I described in my [Practical Server Side Swift book](https://gumroad.com/l/practical-server-side-swift) to build a modular blog engine. If you already purchased the book you should be familiar with most of the system. If you want to know more about server side Swift this is a great opportunity to learn more about building backend apps using Vapor 4. By purchasing the book you also support my work and I'm really grateful for that. Thank you. 🙏

Most of the functionality you see in Feather is provided by modules. There are two types of modules in the engine.

### Core modules

These modules provide basic core functionality. You should never remove them.

- System - This module is responsible for the system functionalities.
- User - This module is responsible for user authentication.
- Api - This module is responsible for the API endpoints.
- Admin - This module is responsible for the web-based admin interface.
- Frontend - This module is responsible for the web-based frontend layout including page contents.

### User modules

These modules can be removed if you don't need them. You can create new user modules to extend the system.

- Redirect - This module is responsible for dynamic URL redirects.
- Blog - This module is responsible for providing a simple blog platform.
- Static - This module is responsible for the displaying static pages.
- Markdown - This module is responsible for displaying markdown via a content filter.
- Syntax - This module is responsible for Swift related syntax highlights using a content filter.
- Sponsor - This module is responsible for displaying a sponsorship box.

--- 

## Hook functions

Modules can communicate via hook functions.

### System hooks

- install - you can populate the database using the install hook.
- frontend-page - you can use this hook to display dynamic content using a specific url pattern (slug)
- page-content - you can use this hook to render pages written as Swift functions
- content-filter - you can apply content filters using this hook

### Page hooks

These hooks can be used via the static page module. You can enter the page value in brackets as the content of a page and Feather will render that page.
For example the [home-page] hook will display the home page provided the blog module, the [posts-page] will display all the available blog posts.

- home-page - Home page with the most recent blog posts
- posts-page - All the blog posts
- categories-page - All the blog categories
- authors-page - All the blog authors

Maybe we should prefix these page hooks with the module name later on, what do you think? 🤔


### Dynamic route hooks

You can hook up routes dynamically via route hooks. Both the frontend, admin and the API module provides some extension points.

- public-admin - publicly available admin pages (usually you don't want to use this)
- protected-admin - protected admin pages (only available after a session based user auth)
- public-api - public api endpoints (available without user authentication)
- protected-api - protected api endpoints (user must be authenticated via a token)

---

## Other 

### Frontend contents

Every user facing content has an associated frontend content type. You can create your own content that can be part of the sitemap and feed items, the static page and the blog module are a great examples of doing this. 

### Content properties

Basics:

- slug - The unique url of the page (without the domain & port)
- status (draft, published, archive) - drafts can be previewed with a noindex meta tag, published contents are public, archived content won't be visible & indexed at all
- date - publish date of the given content
- feed item - if it is true it'll be part of the rss feed
- filters - enabled content filters

SEO related:

- title - meta title of the content
- excerpt - meta description of the content
- image - meta image of the content
- canonical url - additional canonical url

System related:

- module - referenced module name
- model - referenced model name
- reference - referenced unique identifier of the model

### Content filters

Some content can contain special character sequences, it is possible to replace these via content filters. You can write your own filter by using a module hook:


```swift
import Vapor
import Fluent
import ViperKit

final class CustomFilterModule: ViperModule {

    static var name: String = "custom-filter"

    func invokeSync(name: String, req: Request, params: [String: Any]) -> Any? {
        switch name {
        case "content-filter":
            return [CustomFilter()]
        default:
            return nil
        }
    }
}
```

```swift
import Vapor
import Fluent
import ViperKit

struct CustomFilter: ContentFilter {
    var key: String { "custom-filter" }
    var label: String { "Custom filter" }

    func filter(_ input: String) -> String {
        input.replacingOccurrences(of: "hello", with: "hi"))
    }
}
```

The example above will replace the `hello` text to `hi` if you enable the Custom filter for a specific content.

You can find two sample content filters for educational purposes:

- Markdown (Ink)
- Splash


### Page templates

The static page module provides a special functionality called page templates. You can create your own page written in Swift and dynamically hook it up as a template via the static page module.

```swift
import Vapor
import Fluent
import ViperKit

final class ExamplePageTemplateModule: ViperModule {

    static let name = "example-page-template"

	func invoke(name: String, req: Request, params: [String : Any] = [:]) -> EventLoopFuture<Any?>? {
        switch name {
        case "example-page":
            let content = params["page-content"] as! FrontendContentModel
            return try? self.exampleView(req: req, page: content).map { $0 as Any }
        
        default:
            return nil
        }
    }

    func exampleView(req: Request, page content: FrontendContentModel) throws -> EventLoopFuture<Response> {
        return req.view.render("ExamplePageTemplateModule/Frontend/Template")
        .encodeResponse(for: req)
    }
}
```

ExamplePageTemplateModule/Views/Frontend/Template.html

```html
#extend("Frontend/Index"):
    #export("body"):
    	<p>Hello world!</p>
    #endexport
#endextend
```

Since Xcode can't highlight leaf files by default Feather uses the `.html` extension, so we can get partial highlight for the views.

## Views

Views can be loaded using two sources:

- from the Sources/App/Modules/[module]/views directory
- from the Resources/Views/[module] directory

You can copy all the views to the Resources folder by running the `make views` command. 
The system will try to load the view from the Resources directory first, if it can't find then it'll look for it in the Modules directory.


---

## Debug

If you see a `Segmentation fault: 11` error or something similar, you can start the server through the `lldb` debugger. 

```bash
lldb ./.build/debug/Run
process launch serve

# print backtrace
bt
# look up a symbol
image lookup -a 0x1000 
```

Start the debugger and launch the serve command. Then try to repeat the steps that caused the crash.
You can print out the backtrace using the `bt` command, this can help you to identify the problem.

---

## Credits

- [Vapor](https://vapor.codes) - underlying framework
- [Feather icons](https://feathericons.com) - Feather icons
- [Ink](https://github.com/johnsundell/ink) - markdown support
- [Splash](https://github.com/johnsundell/splash) - Swift syntax highlight
- [Sample image #1](https://unsplash.com/photos/5NE6mX0WVfQ)
- [Sample image #2](https://unsplash.com/photos/k0rVudBoB4c)
- [Sample image #3](https://unsplash.com/photos/Mbf3xFiC1Zo)
- [Sample image #4](https://unsplash.com/photos/wpw8sHoBtSY)
- [Sample image #5](https://unsplash.com/photos/5Z9GhJJjiCc)

---

### License

[WTFPL](LICENSE)

