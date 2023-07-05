return {
    preview = {
        function()
            if vim.bo.filetype == "markdown" then
                vim.cmd("MarkdownPreviewToggle")
            end
        end, "Preview Markdown"
    }
}
