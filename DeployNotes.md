# Deploying WikiGraph #

There is a deployment script located in the `bld/` directory name deploy. It assumes that it is being run on the same server as the deployment location and that the user running the deploy script has permission to copy files into the deployment location.

```
Usage: deploy -b <build-number> <Project-Name>
       deploy suggest <Project-Name>

  <Project-Name>: Services, Test-Services, FlashClient, Test-FlashClient

  In the first form it deploys the given project to the appropriate location. If no project is specified, results for all projects are returned.

  In the second form it suggests the most recent builds for each project
  For example:
    deploy suggest Test-Services # returns the newest build for WikiGraph-Test-Services
    deploy -b 28 Test-Services   # will deploy hudson-WikiGraph-Test-Services-28.tar.gz
```

**Note:** Our binaries are built with special configs (see client/FlexClient/DrawGraph/config) that use relative urls. This means that the client must be deployed to the same domain and same path level as the services. For example, if the client is deployed to /var/www/WikiGraph/graph, the services would need to be deployed to /var/www/WikiGraph/api. If you would like to use a different setup, the Config.as file must be modified.