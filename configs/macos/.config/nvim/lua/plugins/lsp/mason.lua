
return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    -- import mason
    local mason = require("mason")

    -- import mason-lspconfig
    local mason_lspconfig = require("mason-lspconfig")

    -- import lspconfig
    local lspconfig = require("lspconfig")

    local mason_tool_installer = require("mason-tool-installer")

    -- enable mason and configure icons
    mason.setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })

    -- use mason_lspconfig to install lsp
    mason_lspconfig.setup({
      -- list of servers for mason to install
      ensure_installed = {
        "lua_ls",
        "pyright",
        "jdtls",
      },
      automatic_installation = true,
      handlers = {
        -- default handler for installed servers
        function(server_name)
          lspconfig[server_name].setup({
            capabilities = require("cmp_nvim_lsp").default_capabilities(),
          })
        end,
        ["svelte"] = function()
          -- configure svelte server
          lspconfig["svelte"].setup({
            capabilities = require("cmp_nvim_lsp").default_capabilities(),
            on_attach = function(client, bufnr)
              vim.api.nvim_create_autocmd("BufWritePost", {
                pattern = { "*.js", "*.ts" },
                callback = function(ctx)
                  -- Here use ctx.match instead of ctx.file
                  client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
                end,
              })
            end,
          })
        end,
        ["graphql"] = function()
          -- configure graphql language server
          lspconfig["graphql"].setup({
            capabilities = require("cmp_nvim_lsp").default_capabilities(),
            filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
          })
        end,
        ["emmet_ls"] = function()
          -- configure emmet language server
          lspconfig["emmet_ls"].setup({
            capabilities = require("cmp_nvim_lsp").default_capabilities(),
            filetypes = {
              "html",
              "typescriptreact",
              "javascriptreact",
              "css",
              "sass",
              "scss",
              "less",
              "svelte",
            },
          })
        end,
        ["lua_ls"] = function()
          -- configure lua server (with special settings)
          lspconfig["lua_ls"].setup({
            capabilities = require("cmp_nvim_lsp").default_capabilities(),
            settings = {
              Lua = {
                -- make the language server recognize "vim" global
                diagnostics = {
                  globals = { "vim" },
                },
                completion = {
                  callSnippet = "Replace",
                },
              },
            },
          })
        end,
        ["pyright"] = function()
          -- configure pyright server (with special settings)
          lspconfig["pyright"].setup({
            capabilities = require("cmp_nvim_lsp").default_capabilities(),
            settings = {
              pyright = {
                disableOrganizeImports = true,
              },
              python = {
                analysis = {
                  useLibraryCodeForTypes = true,
                  typeCheckingMode = "basic",
                },
              },
            },
          })
        end,
        ["jdtls"] = function()
          -- configure java language server
          local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
          local workspace_dir = vim.fn.stdpath('data') .. '/site/java/workspace-root/' .. project_name
          os.execute("mkdir -p " .. workspace_dir)
          
          lspconfig["jdtls"].setup({
            capabilities = require("cmp_nvim_lsp").default_capabilities(),
            cmd = {
              'jdtls',
              '-data', workspace_dir,
            },
            root_dir = lspconfig.util.root_pattern('.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle'),
            settings = {
              
              java = {
                import = {
                  gradle = {
                    enabled = true,
                  },
                },
                eclipse = {
                  downloadSources = true,
                },
                configuration = {
                  updateBuildConfiguration = "interactive",
                },
                maven = {
                  downloadSources = true,
                },
                implementationsCodeLens = {
                  enabled = true,
                },
                referencesCodeLens = {
                  enabled = true,
                },
                references = {
                  includeDecompiledSources = true,
                },
                format = {
                  enabled = true,
                },
              },
              signatureHelp = { enabled = true },
              completion = {
                favoriteStaticMembers = {
                  "org.hamcrest.MatcherAssert.assertThat",
                  "org.hamcrest.Matchers.*",
                  "org.hamcrest.CoreMatchers.*",
                  "org.junit.jupiter.api.Assertions.*",
                  "java.util.Objects.requireNonNull",
                  "java.util.Objects.requireNonNullElse",
                  "org.mockito.Mockito.*",
                },
              },
              contentProvider = { preferred = 'fernflower' },
              extendedClientCapabilities = {
                progressReportsSupported = true,
                classFileContentsSupport = true,
                generateToStringPromptSupported = true,
                hashCodeEqualsPromptSupported = true,
                advancedExtractRefactoringSupported = true,
                advancedOrganizeImportsSupported = true,
                generateConstructorsPromptSupported = true,
                generateDelegateMethodsPromptSupported = true,
                moveRefactoringSupported = true,
              },
              sources = {
                organizeImports = {
                  starThreshold = 9999,
                  staticStarThreshold = 9999,
                },
              },
            },
          })
        end,
      }
    })

    -- use mason_tool_installer to install other non lsp tools
    mason_tool_installer.setup({
      ensure_installed = {
        "prettier", -- prettier formatter
        "stylua", -- lua formatter
        "ruff", -- python formatter
      },
    })
  end,
}
