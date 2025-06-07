-- 加载所有插件模块
return {
    require("plugins.ui"),          -- 界面美化相关
    require("plugins.editor"),      -- 编辑器功能增强
    require("plugins.coding"),      -- 代码编写相关
    require("plugins.lsp"),         -- LSP 相关配置
    require("plugins.dap"),         -- 调试相关插件  
    require("plugins.git"),         -- Git 相关插件
    require("plugins.tools"),       -- 工具类插件
    require("plugins.ai"),          -- AI 相关插件
}
