#!/bin/sh

mvn install:install-file -Dfile=`dirname $0`/flexjson-1.8-custom.jar -DpomFile=`dirname $0`/flexjson-1.8-custom.pom
mvn install:install-file -Dfile=`dirname $0`/struts2jsonresult-0.99.jar -DpomFile=`dirname $0`/struts2jsonresult-0.99.pom
