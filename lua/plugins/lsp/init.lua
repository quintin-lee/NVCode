return {
    require("plugins.lsp.mason"),        -- LSP 安装管理
    require("plugins.lsp.lspconfig"),    -- LSP 配置
    require("plugins.lsp.lspsaga"),      -- LSP UI 增强
    require("plugins.lsp.null-ls"),      -- 格式化和诊断
    require("plugins.lsp.goto-preview"), -- 跳转预览
}
