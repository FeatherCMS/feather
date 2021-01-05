![Feather CMS](https://github.com/FeatherCMS/feather/blob/main/Assets/GitHub-Lead.png?raw=true)

# Feather CMS 🪶


🪶 Feather is a modern Swift-based content management system powered by Vapor 4. 



💬 Click to join the chat on [Discord](https://discord.gg/wMSkxCUXAD). 



## Requirements

To use Feather you'll have to install **Swift 5.3** or greater (using Linux or macOS is recommended).

If you need help installing Swift, you should follow the official instructions available on [swift.org](https://swift.org/download/#releases).



## Installation

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
# the base url of your web server
BASE_URL="http://localhost:8080"

# the base path (absolute) of the working directory
BASE_PATH="/path/to/feather/" 


# Optional environmental variables

# MAX_UPLOAD_SIZE="10mb"
# USE_FILES_MIDDLEWARE="true"

# Available database types: sqlite (default) / mysql / postgres
# DB_TYPE="mysql" 
# DB_HOST="127.0.0.1"
# DB_USER="feather"
# DB_PASS="feather"
# DB_NAME="feather"
# Default port numbers: mysql - 3306 / postgres - 5432
# DB_PORT=3306 

```

You can run the `make env` command to quickly create a development environment with the curret directory as a base path.

Start the server using the `swift run Feather` command (alternatively you can use the `make run` command). 



### Notes about using Xcode

- ⚠️ Warning: DO NOT USE the `swift package generate-xcodeproj` command, it's deprecated.
- ⚠️ Make sure that you open the project by double clicking the `Package.swift` file.
- ⚠️ Set the [custom working directory](https://theswiftdev.com/beginners-guide-to-server-side-swift-using-vapor-4/) for the `Feather` scheme to the root of the project directory.
- ⚠️ If needed setup a [post-action script](https://theswiftdev.com/10-short-advices-that-will-make-you-a-better-vapor-developer-right-away/) to automatically shut-down previous server instances (to avoid address in use errors).
- ✅ Build and run the project as usual and enjoy your Feather powered site.



### Docker support

Feather is also available on [DockerHub](https://hub.docker.com/r/feathercms/feathercms), you can use the following command to pull the latest version.

```shell
docker pull feathercms/feathercms:latest
```

You can also build your own images using `docker-compose` for more information check the following [wiki page](https://github.com/FeatherCMS/feather/wiki/Docker)



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

Feather gives you just a few **core modules** that you can also disable, but it is recommended to keep them around.

(e.g you only need an API, without web frontend or admin interface)

- [System](https://github.com/FeatherCMS/system-module) - System functionalities, variables, run modes (install) and (later on) module management.
- [User](https://github.com/FeatherCMS/user-module) - User authentication and role & permission based access control system.
- [Api](https://github.com/FeatherCMS/api-module) - The API module is responsible for hooking up the public and private API endpoints.
- [Admin](https://github.com/FeatherCMS/admin-module) - This module contains standard admin related interface elements and tools.
- [Frontend](https://github.com/FeatherCMS/frontend-module) - Provides the frontend layout including web page and menu management.

Every [other module](https://github.com/FeatherCMS?q=-module&type=&language=) can be completely removed (just alter the SPM dependency & configuration file). 

💡 Feel free to fork this repository and create your own configuration as per needed. 



## Using Feather CMS

After the server is running Feather will setup everything you need to run your site. 

- Bundled resources (public files and templates) will be copied to the project folder (if needed).

- The first time when you open your page Feather will run in a "system install" mode, during this process:

  - All the necesseary models will be saved to the configured database
  - All the seed assets will be uploaded to the file storage
  - The "root" user account will be created
  - Sample content will be created

- You are ready to use your Feather-based website.

  

#### Root user account

You can log in to the admin interface using the `root@feathercms.com` & `FeatherCMS` user account. 

⚠️ For security reasons, please change the default email & password using the user menu after the first login.



#### User guide

You can read more about how to use Feather in the [wiki](https://github.com/FeatherCMS/feather/wiki).



#### Custom templates

You can create your very own stylesheet by overriding the files inside the `Public` folder.

It is also possible to create custom theme for Feather by altering the templates inside the `Resources` folder.

⚠️ Keep in mind that these files are ignored from the git repository by default. 

👻 You might want to change this behavior by updating your `.gitignore` file.

⭐️ If you delete a file from these folders the next time you run Feather it'll be restored automatically.



## Contribution and support

🪶 Feather is an open source software and your contributions are more than welcome.

🔀 If you wish to make a change, please open a [Pull Request](https://github.com/FeatherCMS/feather/pulls).

🙏 Please don't hesitate to send your feedbacks, thoughts and ideas about Feather.



## Credits

- [Vapor](https://vapor.codes/) - underlying framework
- [Feather icons](https://feathericons.com/) - feather icons



## License

[WTFPL](https://github.com/FeatherCMS/feather/blob/main/LICENSE) - Do What The Fuck You Want Public License



