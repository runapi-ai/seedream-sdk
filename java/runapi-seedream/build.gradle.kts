plugins {
  `java-library`
  `maven-publish`
}

description = "RunAPI Seedream Java SDK for Seedream workflows."

java {
  withSourcesJar()
  withJavadocJar()
}

dependencies {
  api("ai.runapi:runapi-core:0.1.0")

  testImplementation(platform("org.junit:junit-bom:5.10.3"))
  testImplementation("org.junit.jupiter:junit-jupiter")
}

publishing {
  publications {
    create<MavenPublication>("mavenJava") {
      from(components["java"])
      artifactId = "runapi-seedream"
      pom {
        name = "RunAPI Seedream Java SDK"
        description = "RunAPI Seedream Java SDK for Seedream workflows."
        url = "https://runapi.ai/models/seedream"
        licenses {
          license {
            name = "Apache License, Version 2.0"
            url = "https://www.apache.org/licenses/LICENSE-2.0"
          }
        }
        developers {
          developer {
            id = "runapi"
            name = "RunAPI"
            email = "contact@runapi.ai"
          }
        }
        scm {
          url = "https://github.com/runapi-ai/seedream-sdk"
          connection = "scm:git:https://github.com/runapi-ai/seedream-sdk.git"
          developerConnection = "scm:git:ssh://git@github.com/runapi-ai/seedream-sdk.git"
        }
      }
    }
  }
}
