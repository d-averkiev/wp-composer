# wp-flugelit
Wordpress directory structure was changed to convert default WordPress site into a version-controlled Git repository where WordPress, themes, and plugins are installed as a Composer dependency.

The power of this solution lies in the ability to create version-controlled WordPress project where rapid, collaborative theme and plugin development is made easy.

## Prerequisites
To run locally:
Git;
Docker;
Read [Managing Your WordPress Site with Git and Composer](https://deliciousbrains.com/storing-wordpress-in-git/) series. Especially parts 2 and 4.

## What changed in WordPress structure?
1. Makes a better directory structure for your WordPress project which looks like this:
  * /public/ - The publicly-accessible root
  * /public/wp - WordPress files installed by Composer (not included in version control)
  * /public/wp-content - The _wp-content_ directory contains all the plugins and themes unique to your WordPress project. Themes and plugins which installed via composer will be ignored by version control. **If you want to customize theme/plugin, please add exception to .gitignore.** 
  * / - The project root is behind the publicly accessible web root and contains any other dependencies you might want to require in the _vendor_ directory.
2. Improvement in WordPress configuration. In the project root, you'll find a local-config.sample.php - the modified wp-config.php located in the _public_ directory will look first for a production-config.php and then fall back on a local-config.php. This will allow you to seamlessly manage your local/production configuration.

## Local development and testing
1. Clone this repo
2. Install composer dependencies
`docker run --rm --interactive --tty --user $(id -u):$(id -g) --volume $PWD:/app composer:1.6 install`
3. Copy local-config.sample.php to local-config.php and set **your** configuration values
`cp local-config.sample.php local-confi.php`
4. Build dev docker image:
`docker build . -t flugelit-wp:dev`
5. Run container
`docker run --rm -d -p 80:80 -v "$PWD":/var/www/html flugelit-wp:dev`
6. Now Wordpress available on http://127.0.0.1
6. **In your _wp-options_ table, be sure to set your _siteurl_ option to _http://yourdomain.com/wp_ and your _home_ option to _http://yourdomain.com_**

## Misc
**Don't add themes/plugins via admin dashboard. Use composer.json instead.** Run `docker run --rm --interactive --tty --user $(id -u):$(id -g) --volume $PWD:/app composer:1.6 update` after composer.json modification.
Modify the .gitignore according to which parts of _wp-content_ you'd like to include in version control. By default, the _wp-content/uploads_ directory is included to version control.

## Kubernetes
wp-flugelit also contains manifest files to deploy it to Kubernetes cluster. Assumed that the container has the code and all necessary assets, no persistent storage needed. Delivery type - pull container image from registry.
To run project in kuberenetes cluster, you need:
1. Clone repo.
2. Buid production image:
`docker build . --build-arg IS_PROD=true -t [HOSTNAME]/[PROJECT-ID]/[IMAGE]:[VERSION]`
3. Push image to registry
4. Set image kubernetes deployment manifest /deployments/wp-flugelit-deployment.yaml
5. Create secret named `wp-flugelit` for keys `user` and `password` (pun database connection credentials there)
6. Create `configmap` named `wp-flugelit` for keys `db_host` and `db_name`
7. Run deployment
`kubectl create -f deployments/` 

## Credits
This project was forked from Liore Shai `wp-composer` project.
* https://github.com/lioreshai/wp-composer
* liore@a.ai
* https://liore.com
