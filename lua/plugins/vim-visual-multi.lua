return {
  "mg979/vim-visual-multi",
  event = "VeryLazy",
  -- vim-visual-multi 不需要 setup()，导入即生效
  init = function()
    -- 确保不覆盖 <C-n> 以外的常用映射
    -- 默认映射已足够直觉：
    --   <C-n>      选词并添加光标
    --   <C-x>      跳过当前匹配
    --   <C-p>      移除上一个光标
    --   n/N        扩展/缩减选区
    --   q          跳过当前并添加下一个
    --   I/A        在选区首尾插入

    -- 可选：调整高亮颜色
    vim.cmd.hi({
      args = { "VM_Mono", "guifg=#ffffff guibg=#e37400 gui=bold" },
    })
  end,
}
