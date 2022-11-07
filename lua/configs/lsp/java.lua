
local lspconfig = require'lspconfig'.jdtls

lspconfig.cmd = { 'jdtls' }
lspconfig.root_dir = {".git", "mvnw", "gradlew", "pom.xml"}
lspconfig.settings = {
    java = {}
}
lspconfig.init_options = {
    bundles = {}
}

