# Cloud Foundry Java Buildpack + support zip files are having *.war + Shared lib support with YAML upload having maven GAV co-ordinates with custom tomcat,jdk,jce and Valve support with Multiple catalina containers

The `java-buildpack` is a [Cloud Foundry][] buildpack for running JVM-based applications.  It is designed to run many JVM-based applications ([Grails][], [Groovy][], Java Main, [Play Framework][], [Spring Boot][], and Servlet) with no additional configuration, but supports configuration of the standard components, and extension to add custom components.
Also we can push *.zip file which has contain multiple war files. cleartrust-plugin jar will be available in part of buildpack and  will be extracted into tomcat/libs folders. Also Tomcat-Valve config entry will be part of <Host> section in server.xml

currently this buildback has been enhanced  for supporting YAML structure which will have libraries , webapps , repository url , credentials,for getting maven 	application artifacts.
multiple context path mapping also take care.
Added custom tomcat and jdk support with YAML structure.

## shared lib - webapps and custom tomcat,jdk support using YAML file upload
web applications along with supported libraries can be uploaded as YAML format with GAV co-ordinates. below are the sample YAML structure. Also multiple context path
will be dynamically added to Server.xml as a <Context> entry.

```repository:
  location: <LOCATION>
  repo-id: <REPOSITORY>
  authentication:
    username: <username>
    password: <password>
libraries: #specify all libraries as a sequence of GAV Coordinates. These would go in tomcat\lib folder
- g: <groupId>
  a: <artifactId>
  v: <version>
      
webapps: #specify all wars as a sequence of GAV Coordinates this would go into tomcat\webapps folder
- g: <groupId>
  a: <artifactId>
  v: <version>
  context-path: <contextpath>
- g: <groupId>
  a:<artifactId>
  v:<version>
  context-path: /abc
container: #allowed keys for configtomcat[tomcat8,tomcat7,tomcat6] and configjdk[oraclejdk8,oraclejdk7,openjdk8,openkdk7]
   configtomcat: <tomcatkey>
   configjdk: <jdkkey>
```	
all the jars and wars will be downloaded and verify SHA checksum for validation. all the jars will be copied over to tomcat/lib and webapps will have all wars.

###Even shared libs can be (optional). if we want to use libraries as optional then remove the below section from YAML
```
libraries: #specify all libraries as a sequence of GAV Coordinates. These would go in tomcat\lib folder
- g: <groupId>
  a: <artifactId>
  v: <version>
```

## cf push for YAML steps
```
##Following are the steps to push this yaml and test out the buildpack..
1.	Copy the attached YAML to an empty directory
2.	With PWD being the directory in 1 do a "cf p <app-name> -b https://github.com/Covisint-PST/java-buildpack.git”
3.	Your instance should come up with out issue.
4.	Now go to http://<domain>/check. And you should get a success response.
5.	Now go to http://<domain>/classes?className=sample.SampleTCValve. And it will tell the sample.SampleTCValve class was found. This class is part of the library that is being pushed using the manifest and it goes into the shared classpath.
```
##Notes:
1.	Passing the manifest using "–p” does not work. Looks like the CF CLI does not support upload of a single file which is not an Archive. I think this might work using the CF rest APIs. Let me know if it does not.. Will find some work around for you.
2.	Use *.yaml for now. *.yml does not work. Looks like CF CLI strips *.yml files before upload. Should work with the rest API. But stick to *.yaml as that seems to the official extension

##convert YAML file into zip formation and use like below 
```
 cf p <app-name> -b https://github.com/Covisint-PST/java-buildpack.git -p repo-manifest.zip 
```


##Generic support for different jdk , tomcat version with JCE support 
```
	This build has now enhanced to support different jdk and tomcat versions enable via config.yml and based on that versions both jdk(open and Oracle) and tomcat will be downloaded.
Also respective version of JCE security jars will be copied over to jre/security/ folder.	
 cf p <app-name> -b https://github.com/Covisint-PST/java-buildpack.git -p repo-manifest.zip 
```
##Support for Valves with Multiple catalina containers

This build has now enhanced to support different valves which user will set through environment variables.Environment variables which is set as valve will be in JSON format.Which will contain three type of catalina containers which are host,context and engine.Based on these container valve entry with attributes and values will set into respective containers inside server and context xml files.These environment variable user can set with manifest file or through CF cli.Before setting these valves user has to give G,A,V coordinates of jars so that it will download and available under tomcat/lib folder.If user is not providing G,A,V coordinates then user needs to put these jars into tomcat/lib folder. 	

##Setting of Environment variable for Valves
Valves which users are setting here are in JSON format and contains three type of catalina containers.which are host,engine and context.it behaves as key here.
```
{
	"host" : [
				{
				 "className":"c1",
				 "changeSessionIdOnAuthentication":"false",
				 "disableProxyCaching":"false",
				 "securePagesWithPragma":"true"
				},
				{
				 "className":"c2",
				 "alwaysUseSession":"true",
				 "changeSessionIdOnAuthentication":"true"
				}
			 ],
	"engine" :[
				{
				 "className":"c1",
				 "changeSessionIdOnAuthentication":"false",
				 "disableProxyCaching":"false",
				 "securePagesWithPragma":"true"
				},
				{
				 "className":"c2",
				 "alwaysUseSession":"true",
				 "changeSessionIdOnAuthentication":"true"
				}
			  ],
	"context" : [
				 {
				  "className":"c1",
				  "changeSessionIdOnAuthentication":"false",
				  "disableProxyCaching":"false",
				  "securePagesWithPragma":"true"
				 },
				 {
				  "className":"c2",
				  "alwaysUseSession":"true",
				  "changeSessionIdOnAuthentication":"true"
				 }
				] 
}				
```
## Usage
To use this buildpack specify the URI of the repository when pushing an application to Cloud Foundry:

```bash
$ cf push <APP-NAME> -p <ARTIFACT> -b https://github.com/Covisint-PST/java-buildpack.git
```



## Running Tests with Vagrant for Zip supported files
To run the tests, do the following:
Bring up the vagrant virtual machine and ssh into it.

```bash
vagrant up
vagrant ssh
```

Run the `detect`, `compile` and `release` commands within the vagrant machine.

```bash
cd /vagrant/<directory-containing-war-or-zip-files>

/vagrant/vagrant/run/detect
/vagrant/vagrant/run/compile
/vagrant/vagrant/run/release
```

## Cloudfoundry community support
Since this build pack enhanced from cloudofundry java-buildpack , cloudfoundry buildpack related information can be accessed viahttps://github.com/cloudfoundry/java-buildpack/blob/master/README.md