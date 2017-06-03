/**
* NOTE: THIS JENKINSFILE IS GENERATED VIA "./hack/run update"
*
* DO NOT EDIT IT DIRECTLY.
*/
node {
        def variants = "alpine".split(',');
        for (int v = 0; v < variants.length; v++) {

                def versions = "1.4".split(',');
                for (int i = 0; i < versions.length; i++) {

                  if (variants[v] == "default") {
                    variant = ""
                    tag = versions[i]
                  } else {
                    variant = variants[v]
                    tag = versions[i] + "-" + variant
                  }


                        try {
                                stage("Build (Memcached-${tag})") {
                                        openshift.withCluster() {
        openshift.apply([
                                "apiVersion" : "v1",
                                "items" : [
                                        [
                                                "apiVersion" : "v1",
                                                "kind" : "ImageStream",
                                                "metadata" : [
                                                        "name" : "memcached",
                                                        "labels" : [
                                                                "builder" : "memcached-component"
                                                        ]
                                                ],
                                                "spec" : [
                                                        "tags" : [
                                                                [
                                                                        "name" : "${tag}",
                                                                        "from" : [
                                                                                "kind" : "DockerImage",
                                                                                "name" : "memcached:${tag}",
                                                                        ],
                                                                        "referencePolicy" : [
                                                                                "type" : "Source"
                                                                        ]
                                                                ]
                                                        ]
                                                ]
                                        ],
                                        [
                                                "apiVersion" : "v1",
                                                "kind" : "ImageStream",
                                                "metadata" : [
                                                        "name" : "memcached-component",
                                                        "labels" : [
                                                                "builder" : "memcached-component"
                                                        ]
                                                ]
                                        ]
                                ],
                                "kind" : "List"
                        ])
        openshift.apply([
                                "apiVersion" : "v1",
                                "kind" : "BuildConfig",
                                "metadata" : [
                                        "name" : "memcached-component-${tag}",
                                        "labels" : [
                                                "builder" : "memcached-component"
                                        ]
                                ],
                                "spec" : [
                                        "output" : [
                                                "to" : [
                                                        "kind" : "ImageStreamTag",
                                                        "name" : "memcached-component:${tag}"
                                                ]
                                        ],
                                        "runPolicy" : "Serial",
                                        "resources" : [
                                            "limits" : [
                                                "memory" : "2Gi"
                                            ]
                                        ],
                                        "source" : [
                                                "git" : [
                                                        "uri" : "https://github.com/ausnimbus/memcached-component"
                                                ],
                                                "type" : "Git"
                                        ],
                                        "strategy" : [
                                                "dockerStrategy" : [
                                                        "dockerfilePath" : "versions/${versions[i]}/${variant}/Dockerfile",
                                                        "from" : [
                                                                "kind" : "ImageStreamTag",
                                                                "name" : "memcached:${tag}"
                                                        ]
                                                ],
                                                "type" : "Docker"
                                        ]
                                ]
                        ])
        echo "Created memcached-component:${tag} objects"
        /**
        * TODO: Replace the sleep with import-image
        * openshift.importImage("memcached:${tag}")
        */
        sleep 60

        echo "==============================="
        echo "Starting build memcached-component-${tag}"
        echo "==============================="
        def builds = openshift.startBuild("memcached-component-${tag}");

        timeout(10) {
                builds.untilEach(1) {
                        return it.object().status.phase == "Complete"
                }
        }
        echo "Finished build ${builds.names()}"
}

                                }
                                stage("Test (Memcached-${tag})") {
                                        openshift.withCluster() {
        echo "==============================="
        echo "Starting test application"
        echo "==============================="

        def testApp = openshift.newApp("memcached-component:${tag}", "-l app=memcached-ex");
        echo "new-app created ${testApp.count()} objects named: ${testApp.names()}"
        testApp.describe()

        def testAppDC = testApp.narrow("dc");
        echo "Waiting for ${testAppDC.names()} to start"
        timeout(10) {
                testAppDC.untilEach(1) {
                        return it.object().status.availableReplicas >= 1
                }
        }
        echo "${testAppDC.names()} is ready"

        def testAppService = testApp.narrow("svc");
        def testAppHost = testAppService.object().spec.clusterIP;
        def testAppPort = testAppService.object().spec.ports[0].port;

        sleep 60
        echo "Testing endpoint ${testAppHost}:${testAppPort}"
        sh ": </dev/tcp/$testAppHost/$testAppPort"
}

                                }
                                stage("Stage (Memcached-${tag})") {
                                        openshift.withCluster() {
        echo "==============================="
        echo "Tag new image into staging"
        echo "==============================="

        openshift.tag("ausnimbus-ci/memcached-component:${tag}", "ausnimbus/memcached-component:${tag}")
}

                                }
                        } finally {
                                openshift.withCluster() {
                                        echo "Deleting test resources memcached-ex"
                                        openshift.selector("dc", [app: "memcached-ex"]).delete()
                                        openshift.selector("bc", [app: "memcached-ex"]).delete()
                                        openshift.selector("svc", [app: "memcached-ex"]).delete()
                                        openshift.selector("is", [app: "memcached-ex"]).delete()
                                        openshift.selector("pods", [app: "memcached-ex"]).delete()
                                        openshift.selector("routes", [app: "memcached-ex"]).delete()
                                }
                        }

                }
        }
}
