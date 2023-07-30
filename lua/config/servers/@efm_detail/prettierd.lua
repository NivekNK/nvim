-- HACK: Check later for a fix, works for now, seems that is not working with the stdin
return {
	-- formatCommand = "npx prettier --loglevel=silent ${INPUT}",
	-- formatStdin = true,
	formatCommand = "cat ${INPUT} | prettierd ${INPUT}",
	formatStdin = false,
}
