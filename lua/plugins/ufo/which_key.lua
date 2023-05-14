return {
    open_all_folds = { require("ufo").openAllFolds, "Open All Folds" },
    close_all_folds = { require("ufo").closeAllFolds, "Close All Folds" },
    peek_fold = { function()
        local winid = require("ufo").peekFoldedLinesUnderCursor()
        if not winid then
            vim.lsp.buf.hover()
        end
    end, "Peek Fold" },
}
