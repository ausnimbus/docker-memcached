/**
* NOTE: THIS JENKINSFILE IS GENERATED VIA "./hack/run update"
*
* DO NOT EDIT IT DIRECTLY.
*/
node {
        def versions = "1.4".split(',');
        for (int i = 0; i < versions.length; i++) {
                try {
                        stage("Build (Memcached ${versions[i]})") {
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
                                                                        "name" : "${versions[i]}-alpine",
                                                                        "from" : [
                                                                                "kind" : "DockerImage",
                                                                                "name" : "memcached:${versions[i]}-alpine",
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
                                        "name" : "memcached-component-${versions[i]}",
                                        "labels" : [
                                                "builder" : "memcached-component"
                                        ]
                                ],
                                "spec" : [
                                        "output" : [
                                                "to" : [
                                                        "kind" : "ImageStreamTag",
                                                        "name" : "memcached-component:${versions[i]}"
                                                ]
                                        ],
                                        "runPolicy" : "Serial",
                                        "source" : [
                                                "git" : [
                                                        "uri" : "https://github.com/ausnimbus/memcached-component"
                                                ],
                                                "type" : "Git"
                                        ],
                                        "strategy" : [
                                                "dockerStrategy" : [
                                                        "dockerfilePath" : "versions/${versions[i]}/Dockerfile",
                                                        "from" : [
                                                                "kind" : "ImageStreamTag",
                                                                "name" : "memcached:${versions[i]}-alpine"
                                                        ]
                                                ],
                                                "type" : "Docker"
                                        ]
                                ]
                        ])
        echo "Created memcached-component:${versions[i]} objects"
        /**
        * TODO: Replace the sleep with import-image
        * openshift.importImage("memcached:${versions[i]}-alpine")
        */
        sleep 60

        echo "==============================="
        echo "Starting build memcached-component-${versions[i]}"
        echo "==============================="
        def builds = openshift.startBuild("memcached-component-${versions[i]}");

        timeout(10) {
                builds.untilEach(1) {
                        return it.object().status.phase == "Complete"
                }
        }
        echo "Finished build ${builds.names()}"
}

                        }
                        stage("Test (Memcached ${versions[i]})") {
                                openshift.withCluster() {
        echo "==============================="
        echo "Starting test application"
        echo "==============================="

        def testApp = openshift.newApp("memcached-component:${versions[i]}", "-l app=memcached-ex");
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
