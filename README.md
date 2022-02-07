## ⚠️⚠️⚠️ Under construction ⚠️⚠️⚠️

Feather CMS is currently under construction, just a few things about the new version:

- 100% async / await support (requires macOS 12+ or Linux)
- Leaf / Tau is completely replaced with [SwiftHtml](https://github.com/binarybirds/swift-html)
- Simplified core library [FeatherCore](https://github.com/feathercms/feather-core)


![Feather CMS](https://github.com/FeatherCMS/feather/blob/main/Assets/GitHub-Lead.png?raw=true)

# Feather CMS 🪶

🪶 Feather is a modern Swift-based content management system powered by Vapor 4. 

💬 Click to join the chat on [Discord](https://discord.gg/wMSkxCUXAD). 


## Requirements

To use Feather you'll have to install **Swift 5.5** or greater.

If you need help installing Swift, you should follow the official instructions available on [swift.org](https://swift.org/download/#releases).


## Setup & environment

Clone or download the source files using the [Feather](https://github.com/feathercms/feather/) repository. 

```shell
git clone https://github.com/FeatherCMS/feather.git
```
Change the current working directory (located under the target setting when using [Xcode](https://theswiftdev.com/beginners-guide-to-server-side-swift-using-vapor-4/)) to the project directory.

```shell
cd feather
```

Create a dotenv file ( `.env` or `.env.development`) based on your environment) and config the following values.

```shell
# the base path (absolute) of the working directory
FEATHER_WORK_DIR="/path/to/feather/" 

# Optional Feather related env variables

# the hostname (domain) of your web server, default localhost
FEATHER_HOSTNAME=feathercms.com
# the port to listen on, default 8080
FEATHER_PORT=80
# use HTTPS, default false (needs cert & key setup on the Vapor app)
FEATHER_HTTPS=true
# maximum body size for file uploads
FEATHER_MAX_BODY_SIZE=10mb
# disable file middleware, default false (if disabled you can serve files with nginx)
FEATHER_DISABLE_FILE_MIDDLEWARE=true
# disable the session auth middleware for api endpoints (recommended for production)
FEATHER_DISABLE_API_SESSION_MIDDLEWARE=true
```

You can run the `make env` command to quickly create a development environment with the curret directory as a base path.

Start the server using the `swift run Feather` command (alternatively you can use the `make run` command). 



### Notes about using Xcode

- ⚠️ Warning: DO NOT USE the `swift package generate-xcodeproj` command, it's deprecated.
- ⚠️ Make sure that you open the project by double clicking the `Package.swift` file.
- ⚠️ Set the [custom working directory](https://theswiftdev.com/beginners-guide-to-server-side-swift-using-vapor-4/) for the `Feather` scheme to the root of the project directory.
- ⚠️ If needed setup a [post-action script](https://theswiftdev.com/10-short-advices-that-will-make-you-a-better-vapor-developer-right-away/) to automatically shut-down previous server instances (to avoid address in use errors).
- ✅ Build and run the project as usual and enjoy your Feather powered site.



## Configuration

The [FeatherCore framework](https://github.com/feathercms/feather-core) provides all the necessary API to configure your Feather application. 



### Database driver

By default Feather uses the SQLite driver, but it is possible to use PostgreSQL, MySQL (MariaDB) or even MongoDB as your database driver through the [Fluent](https://docs.vapor.codes/4.0/fluent/overview/) framework.

You should follow the instructions using the official Vapor docs to setup the right driver, but please note that the preferred drivers are PosgreSQL and SQLite for really small projects and development purposes.



### File storage driver

The [Liquid framework](https://github.com/binarybirds/liquid/) is an abstract file storage library that works with a local file storage driver, but it is also possible to use Amazon S3 as a cloud-based solution.

You can replace the default local driver with the [S3 driver](https://github.com/BinaryBirds/liquid-aws-s3-driver), which is powered by the [Soto for AWS](https://github.com/soto-project/soto) SDK.



### Modules

Feather is a modular CMS system, you can add new modules as Swift package dependencies or place them under the Modules directory.

Feather gives you just a few **core modules**, they provide basic functionalies such as the route system, web frontend, admin interface or API layer.

The usage of [other modules](https://github.com/feathercms/?q=-module&type=all&language=swift&sort=name) can be completely customized (just alter the SPM dependency & configuration file). 

💡 Feel free to fork this repository and create your own configuration as per needed. 


## Using Feather CMS

### Installation

The first time when you open your page Feather will run in install mode. 

During this phase (behind the scenes):
- all the required database structures will be created (database migration will run automatically).
- Bundled resources (public files) will be copied to the project folder (if needed).
- All the necesseary models will be installed (persisted) using the configured database driver.
- All the required assets will be uploaded to the file storage (using the configured storage driver).
- The "root" user account will be created, you have to provide yor own credentials during this step.
- Sample content for the blog module will be created (you can opt-out from this).
- You'll be redirected to the welcome page. 

Now you are ready to use your Feather-based website.


#### User guide

You can read more about how to use Feather in the [wiki](https://github.com/FeatherCMS/feather/wiki).


## Contribution and support

🪶 Feather is an open source software and your contributions are more than welcome.

🔀 If you wish to make a change, please open a [Pull Request](https://github.com/FeatherCMS/feather/pulls).

🙏 Please don't hesitate to send your feedbacks, thoughts and ideas about Feather.

## Address already in use error

You can use the following command to kill the process listening on the 8080 port. 

```shell
lsof -i :8080 -sTCP:LISTEN |awk 'NR > 1 {print $2}'|xargs kill -15
```

Tip: when using Xcode, edit the scheme and add this as a pre-action script. 

## Credits

- [Vapor](https://vapor.codes/) - underlying framework
- [Feather icons](https://feathericons.com/) - Simply beautiful open source icons
